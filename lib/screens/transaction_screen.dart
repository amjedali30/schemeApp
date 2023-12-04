import 'dart:math';

import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import './home_screen.dart';
import './login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../widgets/transaction_list.dart';
import '../providers/transaction.dart';
import '../providers/user.dart';
import './login_screen.dart';

class TransactionScreen extends StatefulWidget {
  static const routeName = "/transaction-screen";

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  var user;
  bool? _checkValue;
  Transaction? db;
  User? dbUser;
  List transactionList = [];
  List userList = [];
  DateTime lastUpdate = DateTime.now();
  double customerBalance = 0;
  double totalGram = 0;
  List alllist = [];

  List userData = [];

  initialise() {
    Provider.of<User>(context, listen: false).readById(userId).then((value) {
      setState(() {
        userData = value!;
      });
    });
    db = Transaction();

    db!.initiliase();

    db!.read(userId).then((value) {
      print(userId);
      setState(() {
        alllist = value!;

        transactionList = alllist[0] != null ? alllist[0] : [];
        customerBalance = alllist[1];
        totalGram = alllist[2];
      });
      // print("========+++++++++++");
      // print(transactionList);
      // print("user");
      // print(transactionList[1]);
    });
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getKeys();
    for (String key in preferences.getKeys()) {
      preferences.remove(key);
    }
    setState(() {});
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => new HomeScreen()));

    // Navigate Page
    // Navigator.of(context).pushNamed(HomeScreen.routeName);
  }

  // @override
  // void didChangeDependencies() async {

  // }
  String userId = "";
  String userName = "";
  String userPhone = "";
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _checkValue = prefs.containsKey('user');

    userId = jsonDecode(prefs.getString('userId')!);
    userName = jsonDecode(prefs.getString('username')!);
    userPhone = jsonDecode(prefs.getString('userPhone')!);
    print(userName);
    initialise();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();

    // user = prefs.containsKey('user');
  }

  @override
  Widget build(BuildContext context) {
    if (transactionList.length > 0) {
      lastUpdate = transactionList[0]['date'].toDate();
    }

    // if (userList != null) {
    //   customerBalance = userList[0]['balance'].toDouble();
    //   totalGram = userList[0]["totalGram"].toDouble();
    // }

    // Clear shared preferance

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (context) => new HomeScreen()));
          },
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
        ),
        title: Text(
          "TRANSACTIONS",
          style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'latto',
              fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('! Log out '),
                  // content: Text('Log out of Angadi'),
                  actions: <Widget>[
                    OutlinedButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                    OutlinedButton(
                      child: Text('Log Out'),
                      onPressed: () {
                        logout();
                      },
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: transactionList.length > 0
          ? Container(
              // padding: EdgeInsets.only(top: 35),
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.only(top: 20, left: 18, right: 18),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 6,
                          child: Card(
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              // side: BorderSide(
                              //   color: Colors.purple.withOpacity(0.2),
                              //   width: 1,
                              // ),
                            ),
                            color: Colors.grey[50],
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * .1,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Available balance is",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontFamily: 'latto'),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.piggyBank,
                                                  size: 17,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  customerBalance != ""
                                                      ? "+ ₹  ${customerBalance}"
                                                      : " + ₹ 00",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'latto',
                                                      fontSize: 15),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Container(
                                          width: 1,
                                          height: 100,
                                          color: Colors.black12,
                                        ),
                                      ),
                                      userData[0]["customerType"] == "0"
                                          ? Expanded(
                                              child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Total Gram ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.grey[500],
                                                        fontFamily: 'latto'),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      FaIcon(
                                                        FontAwesomeIcons.coins,
                                                        size: 17,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        totalGram != 0
                                                            ? "${totalGram.toStringAsFixed(4)}"
                                                            : "0.00",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily: 'latto',
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ))
                                          : Container()
                                    ],
                                  ),
                                ),
                                Flexible(
                                    child: Container(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Last updated at",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'latto',
                                            color: Colors.grey[400]),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            DateFormat.yMMMd()
                                                // .add_jm()
                                                .format(lastUpdate)
                                                .toString(),
                                            style: TextStyle(
                                                fontFamily: 'latto',
                                                fontSize: 11,
                                                color: Colors.grey),
                                          ))
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Row(
                        children: [
                          Text(
                            "Transaction List",
                            style: TextStyle(
                              fontFamily: 'latto',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      height: 10,
                      thickness: 0,
                      indent: 0,
                      endIndent: 0,
                      color: Colors.black12,
                    ),
                    TransactionList(
                        transaction: transactionList,
                        type: userData[0]["customerType"]),
                  ],
                ),
              ),
            )
          : Center(
              child: EmptyWidget(
                image: null,
                packageImage: PackageImage.Image_1,
                title: 'No data found',
                subTitle: 'No  transaction available yet',
                titleTextStyle: TextStyle(
                  fontSize: 22,
                  color: Color(0xff9da9c7),
                  fontWeight: FontWeight.w500,
                ),
                subtitleTextStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xffabb8d6),
                ),
              ),
            ),
    );
  }
}
