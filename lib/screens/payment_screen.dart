import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../functions/SHA256.dart';
import '../functions/base64.dart';
import '../providers/phonePe_payment.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'paymentResponseScreen.dart';

// import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment-screen';
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  double paidAmount = 0;
  String description = "";
  bool webview = false;
  var userData;
  String custId = "";
  String userName = "";
  double mobileNo = 0;
  String status = "";
  String transactionId = "";
  var paymentDetails;
  Future checkUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user = pref.getString("user");
    // var user = pref.get("user");
    if (user != null) {
      var decodedJson = json.decode(user);
      userData = decodedJson;
      print("----------");
      print(user);
      setState(() {
        custId = userData["custId"];
        userName = userData["name"];
        mobileNo = double.parse(userData["phoneNo"]);
      });
      // print(custId);
      // print(userName);
      // print(mobileNo);
    } else {
      //user not exist in sharedprefrence
      print("loginscreen");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  var inserUrl = "https://sarathihelp.com/phonepay/api/insert_payment";
  var phonePeUrl = "https://api.phonepe.com/apis/hermes/pg/v1/pay";
  var rediarectUrl = "https://sarathihelp.com/phonepay/api/paymentResponse";
  var checkServerAPI = "https://sarathihelp.com/phonepay/api/paymentStatus";
  String saltKey = "e7d1dcd1-c6c2-427a-b175-bded5f438f9d";
  String _merchantId = "THRISSURONLINE";
  bool pressPay = false;

  tokenGenarate(String amt, String note) async {
    var amount = double.parse(amt);

    var data = phonePe_PaymentModel(
        merchantId: _merchantId,
        custId: custId,
        custName: userName,
        amount: amount,
        note: note,
        custPhone: mobileNo,
        currency: "INR",
        status: "Initaiated");

    firebaseInsert(data);
  }

  // ------ insert transtaction data in firebase ---------
  firebaseInsert(var data) {
    var db = phonePe_Payment();
    db.initiliase();
    db.addTransaction(data).then((value) {
      // print("----payment data ----");
      setState(() {
        transactionId = value.toUpperCase();
      });
      print("----- Firebase insert ----------");
      print(transactionId);
      if (transactionId != "") {
        insertAPI(data.amount, data.note, transactionId);
      } else {
        // print("----- Firebase insert error----------");
      }
    });
  }

// ------ insert transtaction data in Backend ---------
  insertAPI(double amt, String note, String transId) async {
    // print("---- Backend Insert  -----------");
    // print(inserUrl);
    // print(custId);
    // print(_merchantId);
    // print(amt);
    // print(userName);
    // print(transId);
    // print(note);
    var rspncData;
    phonePeFn(amt, transId);
    // final response = await http.post(
    //   Uri.parse(inserUrl),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Content-type': 'application/json',
    //     '_token': "SnPm0X8XsudS0klJjW31B0RkI2w5pFfxOZog8kbt"
    //   },
    //   body: jsonEncode({
    //     "customer_id": custId,
    //     "amount": amt * 100,
    //     "customer_name": userName,
    //     "merchantId": _merchantId,
    //     "transaction_id": transId,
    //     "message": note
    //   }),
    // );
    // print("---- Backend Insert  -----------");
    // print(rspncData);
    // setState(() {
    //   rspncData = jsonDecode(response.body);
    // });
    // print("---- Backend Insert  -----------");
    // print(rspncData);
    // if (rspncData["statusCode"] == 200) {
    //   phonePeFn(amt, transId);
    // } else {
    //   // print("---- Backend Insert Error -----------");
    // }
  }

  // --------- PhonePe API -------------
  phonePeFn(double amount, String transactionId) async {
    String base64data = "";
    String input;
    String hashedOutput;
    String hash = "";
    var data1;
    var url;

    var PhonePedata = {
      "merchantId": _merchantId,
      "merchantTransactionId": transactionId,
      "merchantUserId": custId,
      "amount": amount * 100,
      "redirectUrl": rediarectUrl,
      "redirectMode": "POST",
      "callbackUrl": rediarectUrl,
      "mobileNumber": mobileNo,
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
    setState(() {});
    print(PhonePedata);
    setState(() {
      base64data = encodeJsonToBase64(PhonePedata);
      input = base64data + "/pg/v1/pay" + saltKey;
      hashedOutput = convertToSHA256(input);
      hash = hashedOutput + "###" + "1";
    });

    final response = await http.post(
      Uri.parse(phonePeUrl),
      headers: {
        'Content-Type': 'application/json',
        'Content-type': 'application/json',
        'X-VERIFY': hash
      },
      body: jsonEncode({"request": base64data}),
    );

    setState(() {
      data1 = jsonDecode(response.body);
    });
    print("-----------------------------------");
    print(data1);
    setState(() {
      url = data1["data"]["instrumentResponse"]["redirectInfo"]["url"];
    });

    _launchURL(
      url,
      data1["data"]["merchantTransactionId"],
      data1["data"]["merchantId"],
      amount * 100,
    );
  }

  _launchURL(
      var data, String transactionId, String merchantId, double amount) async {
    final Uri url = Uri.parse(data);

    launchUrl(url, mode: LaunchMode.inAppWebView).then((value) {
      // launch(url.toString()).then((value) {
      print("================");
      print(value);
      setState(() {
        webview = value;
        _isLoading = true;
      });

      if (webview == true) {
        _startTimer(transactionId, merchantId, amount);
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer1.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }),
        // leading: Icon(Icons.arrow_back_ios),
      ),
      body: webview == false
          ? Container(
              width: double.infinity,
              height: 800,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("Hello...",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        userData != null ? userName.toUpperCase() : "",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: IntrinsicWidth(
                          child: TextField(
                            onChanged: (amountController) {
                              setState(() {});
                            },
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontSize: 40.0,
                                height: 2.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                FontAwesomeIcons.rupeeSign,
                                size: 25,
                                color: Colors.black,
                              ),
                              hintText: "0",
                              hintStyle: TextStyle(fontSize: 50),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                          width: 250,
                          height: 65,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: IntrinsicWidth(
                                child: TextField(
                                  controller: noteController,
                                  onChanged: (noteController) {
                                    setState(() {});
                                  },
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black),
                                  decoration: InputDecoration(
                                      hintText: "add a note",
                                      hintStyle: TextStyle(fontSize: 14),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                  Container(
                    height: 50,
                    width: 150,
                    child: amountController.text.isEmpty
                        ? Center(child: Text("Pay Now"))
                        : pressPay == false
                            ? Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        pressPay = true;
                                      });
                                      final snackBar = SnackBar(
                                          content:
                                              Text("please add note....!"));
                                      noteController.text.isNotEmpty
                                          ? tokenGenarate(amountController.text,
                                              noteController.text)
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                      ;
                                    },
                                    child: Text(
                                      "Pay Now",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    )))
                            : Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                    child: Text(
                                  "Wait...!",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ))),
                  )
                ],
              ),
            )
          : Center(
              child: _isLoading
                  ? Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .3,
                            width: MediaQuery.of(context).size.height * .3,
                            child: Image(
                                image: AssetImage("assets/images/wait.jpg")),
                          ),
                          Text(
                            "\" Don't Press Back \" ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "don't press back while payment initiating...!",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12),
                          )
                        ],
                      ),
                    )
                  : success
                      ? ResponseScreen(
                          response: paymentDetails,
                          note: noteController.text,
                        )
                      : error
                          ? ResponseScreen(
                              response: paymentDetails,
                              note: noteController.text)
                          : Container()),
    );
  }

  double _progressValue = 0.0;
  bool _isLoading = false;
  bool success = false;
  bool error = false;
  late Timer timer1;
  void _startTimer(String transactionId, String merchantId, double amount) {
    // print("---------- merchentId -------");
    // print(merchantId);
    const oneSecond = const Duration(seconds: 2);
    Timer.periodic(oneSecond, (timer1) {
      setState(() {
        statusApi(merchantId, transactionId);
        _progressValue +=
            0.008; // Increment the progress value by 1/60th (approx. 0.0167) every second for 2 minutes
        if (_progressValue >= 2.0) {
          timer1.cancel();
        }
      });
    });
  }

  statusApi(String merchantId, String merchantTransactionId) async {
    String input;
    String hashedOutput;
    String hash;

    input = "/pg/v1/status/${merchantId}/${merchantTransactionId}" + saltKey;
    hashedOutput = convertToSHA256(input);
    var url =
        "https://api.phonepe.com/apis/hermes/pg/v1/status/${merchantId}/${merchantTransactionId}";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Content-type': 'application/json',
        'X-VERIFY': "${hashedOutput}###1",
        "X-MERCHANT-ID": merchantId

        //  hash
      },
    );
    // print("----------phonepe payment Status Response -------");
    // print(response.reasonPhrase);
    var data;
    setState(() {
      data = jsonDecode(response.body);
      paymentDetails = data;
      pressPay = false;
    });

    if (data["code"] == "PAYMENT_ERROR") {
      setState(() {
        _isLoading = false;
        error = true;
        _progressValue = 2.0;
      });
      closeInAppWebView();
      // checkTransctionApi(data["data"]["merchantTransactionId"],
      //     data["data"]["merchantId"], data["data"]["amount"]);
      // // print("================================================");
      // // print(containApi);
      // if (containApi == true) {
      //   setState(() {
      //     _isLoading = false;
      //     error = true;
      //     _progressValue = 2.0;
      //   });
      // }
    } else if (data["code"] == "PAYMENT_SUCCESS") {
      setState(() {
        _isLoading = false;
        error = false;
        success = true;
        _progressValue = 2.0;
      });
      closeInAppWebView();
      // checkTransctionApi(data["data"]["merchantTransactionId"],
      //     data["data"]["merchantId"], data["data"]["amount"]);
      // // print("================================================");
      // // print(containApi);
      // if (containApi == true) {
      //   setState(() {
      //     _isLoading = false;
      //     error = false;
      //     success = true;
      //     _progressValue = 2.0;
      //   });
      // }
    }
  }

  bool containApi = false;
  late String apiResult;
  checkTransctionApi(
      String merchantTransactionId, String merchantId, int amount) async {
    // print("----------checkTransctionApi -------");
    final apiResponse = await http.post(
      Uri.parse(checkServerAPI),
      headers: {
        'Content-Type': 'application/json',
        'Content-type': 'application/json',
      },
      body: jsonEncode({
        "transactionId": merchantTransactionId,
        "merchantId": merchantId,
        "amount": amount
      }),
    );
    // print("---------- API Status Response -------");
    var data = jsonDecode(apiResponse.body);
    print("=========== ++++++++++++++++");
    print(data);
    setState(() {
      containApi = data["status"];
    });
    // print("0000000000000000000000");
    // print(containApi);

    return containApi;
  }
}
