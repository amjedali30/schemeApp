import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentModel {
  int? orderId;
  String? custId;
  double? amount;
  String? note;
  String? custName;

  String? custPhone;
  String? tokenData;
  String? status;

  PaymentModel({
    this.orderId,
    this.custId,
    this.amount,
    this.note,
    this.custName,
    this.custPhone,
    this.tokenData,
    this.status,
  });
}

class Payment with ChangeNotifier {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('payment');
  Future<void> genarateData(PaymentModel paymentModel) async {
    try {
      QuerySnapshot querySnapshot =
          await collectionReference.orderBy("orderId").limitToLast(1).get();
      print(querySnapshot.docs);
      List lastData = [];
      for (var doc in querySnapshot.docs.toList()) {
        Map a = {
          "id": doc.id,
          "orderId": doc["orderId"],
          "amount": doc["amount"],
        };
        lastData.add(a);
        print(lastData);
      }

      int defaultId = 120;
      if (querySnapshot.docs.isNotEmpty) {
        // Collection exits
        print("Collection exits");

        final url = "https://test.cashfree.com/api/v2/cftoken/order";
        try {
          defaultId = lastData[0]["orderId"] + 1;
          print(defaultId);
          final response = await http.post(
            Uri.parse(url),
            headers: {
              'Content-type': 'application/json',
              'Accept': 'application/json',
              'x-client-id': '202822fec06315ad871dc6aee9228202',
              'x-client-secret': '745ceaf51af561149ac551a1936c23c3e9326c02',
            },
            body: jsonEncode({
              "orderId": defaultId, //orderId
              "orderAmount": paymentModel.amount,
              "orderCurrency": "INR"
            }),
          );

          var jsonResponse = jsonDecode(response.body);

          collectionReference.add({
            "orderId": defaultId,
            "custId": paymentModel.custId,
            "amount": paymentModel.amount,
            "note": paymentModel.note,
            "custName": paymentModel.custName,
            "custPhone": paymentModel.custPhone,
            "tokenData": jsonResponse["cftoken"],
            "status": "",
          });
        } catch (err) {
          throw err;
        }
      } else {
        int orderId = defaultId;
        // Collection not exits
        print("Collection not exits");
        final url = "https://test.cashfree.com/api/v2/cftoken/order";
        try {
          final response = await http.post(
            Uri.parse(url),
            headers: {
              'Content-type': 'application/json',
              'Accept': 'application/json',
              'x-client-id': '202822fec06315ad871dc6aee9228202',
              'x-client-secret': '745ceaf51af561149ac551a1936c23c3e9326c02',
            },
            body: jsonEncode({
              "orderId": orderId,
              "orderAmount": paymentModel.amount,
              "orderCurrency": "INR"
            }),
          );

          var jsonResponse = jsonDecode(response.body);

          collectionReference.add({
            "orderId": defaultId,
            "custId": paymentModel.custId,
            "amount": paymentModel.amount,
            "note": paymentModel.note,
            "custName": paymentModel.custName,
            "custPhone": paymentModel.custPhone,
            "tokenData": jsonResponse["cftoken"],
            "status": "",
          });
        } catch (err) {
          throw err;
        }
        print("else");
      }
    } catch (e) {}
  }

  Future<List> getPaymentData() async {
    List paymentData = [];
    try {
      // QuerySnapshot querySnapshot = await collectionReference.get();
      QuerySnapshot querySnapshot =
          await collectionReference.orderBy("orderId").limitToLast(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "orderId": doc["orderId"],
            "amount": doc["amount"],
            "note": doc["note"],
            "custName": doc["custName"],
            "custPhone": doc["custPhone"],
            "tokenData": doc["tokenData"],
          };
          paymentData.add(a);
        }
      }

      return paymentData;
    } catch (e) {
      rethrow;
    }
  }

  Future updateStatus(String status) async {
    QuerySnapshot querySnapshot =
        await collectionReference.orderBy("orderId").limitToLast(1).get();
    print(querySnapshot);
    var lastData = [];
    for (var doc in querySnapshot.docs.toList()) {
      Map a = {
        "id": doc.id,
        "orderId": doc["orderId"],
        "amount": doc["amount"],
      };
      lastData.add(a);
    }

    collectionReference.doc(lastData[0]["id"]).update({"status": status});
    // .docs[].update({"status": status});
    //  collectionReference.where(status, isEqualTo: "SUCCESS");

    // collectionReference.add(status = "FAILD");
  }
}
