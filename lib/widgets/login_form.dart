import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../screens/home_screen.dart';

import '../Providers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/transaction_screen.dart';

class LoginForm extends StatefulWidget {
  // static const routeName = "/login-screen-form";
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  User? db;

  List userList = [];
  List filterList = [];
  bool isSubmit = false;
  var index;

  Future initialise() async {
    db = User();
    db?.initiliase();
    await db?.read().then((value) {
      setState(() {
        userList = value!;
      });
      // if (userList.length > 0) {
      //   final snackBar = SnackBar(
      //     content: const Text('ready!'),
      //   );
      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // }
    });
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  TextEditingController _customerIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _form = GlobalKey<FormState>();
  TextStyle style = TextStyle(
    fontFamily: 'latto',
    fontSize: 20.0,
    color: Colors.white,
  );

  // login() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  //   List user = [];
  //   filterList = userList
  //       .where((element) => (element['custId']
  //           .toLowerCase()
  //           .contains(_customerIdController.text.toLowerCase())))
  //       .toList();
  //   print("=====2=2=2=2=2=2=2==++++");
  //   print(filterList);
  //   // CollectionReference collectionReference =
  //   //     FirebaseFirestore.instance.collection('user');
  //   // QuerySnapshot querySnapshot = await collectionReference.get();

  //   // for (var doc in querySnapshot.docs.toList()) {
  //   //   Map a = {
  //   //     "id": doc.id,
  //   //     "name": doc['name'],
  //   //     "custId": doc["custId"],
  //   //     "phoneNo": doc["phone_no"],
  //   //     "address": doc["address"],
  //   //     "place": doc["place"],
  //   //     "balance": doc["balance"],
  //   //     "staffId": doc["staffId"],
  //   //     "token": doc["token"],
  //   //     "schemeType": doc["schemeType"],
  //   //     "total_gram": doc["total_gram"],
  //   //     "branch": doc['branch'],
  //   //     "dateofBirth": doc['dateofBirth'],
  //   //     "nominee": doc['nominee'],
  //   //     "nomineePhone": doc['nomineePhone'],
  //   //     "nomineeRelation": doc['nomineeRelation'],
  //   //     "adharCard": doc['adharCard'],
  //   //     "panCard": doc['panCard'],
  //   //     "pinCode": doc['pinCode'],
  //   //     "staffName": doc['staffName'],
  //   //   };
  //   //   user.add(a);
  //   // }

  //   // setState(() {
  //   //   filterList = user
  //   //       .where((element) => (element['custId']
  //   //           .toLowerCase()
  //   //           .contains(_customerIdController.text.toLowerCase())))
  //   //       .toList();
  //   // });

  //   if (filterList.isNotEmpty &&
  //       filterList[0]['custId'] == _customerIdController.text) {
  //     if (filterList[0]['phoneNo'] == _passwordController.text) {
  //       print("=========");
  //       // sharedPreferences.setString(
  //       //     "user", json.encode(filterList[0].toString()));
  //       // sharedPreferences.setString(
  //       //     "userId", json.encode(filterList[0]['id'].toString()));
  //       // sharedPreferences.setString(
  //       //     "username", json.encode(filterList[0]['name'].toString()));
  //       // sharedPreferences.setString(
  //       //     "userPhone", json.encode(filterList[0]['phoneNo'].toString()));

  //       token = (await FirebaseMessaging.instance.getToken())!;
  //       // print("####################");
  //       // print(token);
  //       setState(() {
  //         isSubmit = false;
  //       });
  //       if (filterList[0]['token'] == "" || filterList[0]['token'] == null) {
  //         FirebaseFirestore.instance
  //             .collection('user')
  //             .doc(filterList[0]['id'])
  //             .set({'token': token}, SetOptions(merge: true));
  //       }
  //       final snackBar = SnackBar(
  //         content: const Text('Logging Success.....'),
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //       setState(() {
  //         isSubmit = false;
  //       });
  //       Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
  //           (Route<dynamic> route) => false);
  //     } else {
  //       final snackBar = SnackBar(
  //         content: const Text('Wrong password!'),
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //       setState(() {
  //         isSubmit = false;
  //       });
  //     }
  //   } else {
  //     final snackBar = SnackBar(
  //       content: const Text('Customer id is invalid!'),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     setState(() {
  //       isSubmit = false;
  //     });
  //   }
  // }

  login(String custId, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // print(custId);
    // print(password);

    filterList = await userList
        .where((element) => (element['custId']
            .toLowerCase()
            .contains(_customerIdController.text.toLowerCase())))
        .toList();
    print("=====2=2=2=2=2=2=2==++++");
    print(filterList);
    if (filterList.length > 0) {
      if (filterList[0]['custId'] == custId) {
        if (filterList[0]['phoneNo'] == password) {
          sharedPreferences.setString(
              "user", json.encode(filterList[0].toString()));
          sharedPreferences.setString(
              "userId", json.encode(filterList[0]['id'].toString()));
          sharedPreferences.setString(
              "username", json.encode(filterList[0]['name'].toString()));
          sharedPreferences
              .setString(
                  "userPhone", json.encode(filterList[0]['phoneNo'].toString()))
              .then((value) {
            tockenGen();
          });
          print("======READY");
          final snackBar = SnackBar(
            content: const Text('Logging Success.....'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            isSubmit = false;
          });
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()),
              (Route<dynamic> route) => false);
        } else {
          final snackBar = SnackBar(
            content: Text("Incorrect Password...!"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            isSubmit = false;
          });
        }
      } else {
        final snackBar = SnackBar(
          content: const Text("Customer does't exist...!"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isSubmit = false;
        });
      }
    } else {
      final snackBar = SnackBar(
        content: const Text('Customer id is invalid.....!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        isSubmit = false;
      });
    }
  }

  tockenGen() async {
    String? token = await FirebaseMessaging.instance.getToken();
    // print(token);
    if (filterList[0]['token'] == "" || filterList[0]['token'] == null) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(filterList[0]['id'])
          .set({'token': token}, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _form,
        child: Container(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(children: <Widget>[
            TextFormField(
              controller: _customerIdController,
              textAlign: TextAlign.left,
              // controller: _emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide Valid customer id.';
                }
                return null;
              },
              obscureText: false,
              style: TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: "Customer Id",
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _passwordController,
              textAlign: TextAlign.left,
              // controller: _emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide a value.';
                }
                return null;
              },
              obscureText: false,
              style: TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            isSubmit == false
                ? Material(
                    elevation: 1.0,
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () {
                        // Navigator.of(context).pushNamed(TransactionScreen.routeName);
                        setState(() {
                          isSubmit = true;
                        });

                        if (isSubmit == true) {
                          login(_customerIdController.text,
                              _passwordController.text);
                        }
                      },
                      child: Text("Login",
                          textAlign: TextAlign.center,
                          style: style.copyWith(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                : Material(
                    elevation: 1.0,
                    borderRadius: BorderRadius.circular(12.0),
                    color: Color.fromARGB(255, 34, 34, 34),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () {
                        // Navigator.of(context).pushNamed(TransactionScreen.routeName);
                        // setState(() {
                        //   isSubmit = true;
                        // });
                        // if (isSubmit == true) {
                        //   login();
                        // }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Login",
                              textAlign: TextAlign.center,
                              style: style.copyWith(
                                  color: Color.fromARGB(255, 244, 244, 244),
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 8,
                              backgroundColor: Colors.white,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          ]),
        ),
      ),
    );
  }
}
