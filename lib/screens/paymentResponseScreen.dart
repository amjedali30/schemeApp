import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/phonePe_payment.dart';
import '../providers/transaction.dart';
import 'home_screen.dart';

class ResponseScreen extends StatefulWidget {
  ResponseScreen({this.response, required this.note});
  var response;
  String note;
  @override
  State<ResponseScreen> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  var response;
  var userData;
  String custId = "";
  String userName = "";
  double mobileNo = 0;

  var paymentDetails;
  Future checkUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user = pref.getString("user");
    if (user != null) {
      var decodedJson = json.decode(user);
      userData = decodedJson;
      // print("----------");
      // print(userData);
      setState(() {
        custId = userData["custId"];
        userName = userData["name"];
        mobileNo = double.parse(userData["phoneNo"]);
      });
      // print(custId);
      // print(userName);
      // print(mobileNo);
    }
    if (response["code"] == "PAYMENT_SUCCESS") {
      addTransaction();
    }
  }

  updateFirebaseStatus() {
    var db = phonePe_Payment();
    db.initiliase();
    db
        .updatePaymentbyTransactionId(response["data"]["merchantTransactionId"],
            response["code"], response)
        .then((value) {
      print("------------- value ----------");
      // print(value);
    });
  }

  DateTime today = DateTime.now();
  addTransaction() async {
    var data = TransactionModel(
        id: "",
        customerName: userName,
        customerId: userData["id"],
        date: today,
        amount: response["data"]["amount"].toDouble() / 100,
        transactionType: 0,
        note: widget.note,
        invoiceNo: response["data"]["merchantTransactionId"],
        category: "GOLD",
        discount: 0,
        staffId: "");
    var db = Transaction();
    db.initiliase();
    db.create(data).then((value) {
      final snackBar =
          SnackBar(content: const Text("Transaction Add Successfully...."));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => TransactionScreen()));
    });
  }

  var amount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      response = widget.response;
      amount = response["data"]["amount"] / 100;
    });
    print(response);
    checkUser();

    updateFirebaseStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: GestureDetector(
      //       onTap: () {
      //         Navigator.pushAndRemoveUntil(
      //             context,
      //             MaterialPageRoute(builder: (context) => HomeScreen()),
      //             (route) => true);
      //       },
      //       child: Icon(Icons.close_rounded)),
      //   actions: [
      //     Icon(Icons.ios_share),
      //     SizedBox(
      //       width: 10,
      //     ),
      //   ],
      // ),
      bottomNavigationBar: Container(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .06,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Color(0xFFcc9900),
                    width: 2.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_download_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Get PDF Receipt",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false);
                },
                child: Container(
                    height: MediaQuery.of(context).size.height * .06,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Color(0xFFcc9900),
                    ),
                    child: Center(
                        child: Text(
                      "Done",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white),
                    ))),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          // color: Colors.red,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .06,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                                (route) => false);
                          },
                          child: Icon(Icons.close_rounded)),
                      Icon(Icons.ios_share),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .15,
                child: Center(
                  child: response["code"] == "PAYMENT_SUCCESS"
                      ? CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFFe6fff2),
                          child: CircleAvatar(
                            radius: 20,
                            child: Image(
                              fit: BoxFit.scaleDown,
                              image: AssetImage("assets/images/checked.png"),
                            ),
                          ),
                        )
                      : Image(
                          fit: BoxFit.scaleDown,
                          image: AssetImage(
                              "assets/images/Screenshot 2023-06-22 at 3.08.47 PM.png"),
                        ),
                ),
              ),
              response["code"] == "PAYMENT_SUCCESS"
                  ? Text(
                      "Payment Success!",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )
                  : Text(
                      "Payment Failed!",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
              SizedBox(
                height: 10,
              ),
              response["code"] == "PAYMENT_SUCCESS"
                  ? Text(
                      "Your payment has been successfully done.",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    )
                  : Text(
                      "Your payment has been Failed",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .4,
                  decoration: BoxDecoration(
                      color: Color(0xFFf0f5f5),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * .11,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .11,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("Amount"),
                                          Text("Payment Status")
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .11,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(amount.toString()),
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .04,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .25,
                                            decoration: BoxDecoration(
                                                color: response["code"] ==
                                                        "PAYMENT_SUCCESS"
                                                    ? Color(0xFFadebad)
                                                    : Color(0xFFffb3b3),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Center(
                                              child: response["code"] ==
                                                      "PAYMENT_SUCCESS"
                                                  ? Text(
                                                      "Success",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF196619)),
                                                    )
                                                  : Text(
                                                      "Failed",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF660000)),
                                                    ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 210,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("Ref Number"),
                                          Text("Merchant Name"),
                                          response["code"] == "PAYMENT_SUCCESS"
                                              ? Text("Payment Method")
                                              : Container(),
                                          Text("Payment Time"),
                                          Text("Sender")
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 210,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(response["data"]
                                                  ["transactionId"]),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("Oro Gold"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: response["code"] ==
                                                      "PAYMENT_SUCCESS"
                                                  ? Text(response["data"]
                                                          ["paymentInstrument"]
                                                      ["type"])
                                                  : Container(),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  "Mar 22, 2023, 13:22:16"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child:
                                                  Text(userName.toUpperCase()),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
