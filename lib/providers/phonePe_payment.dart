import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class phonePe_PaymentModel {
  String custId;
  String custName;
  double amount;
  String note;
  double custPhone;
  String merchantId;
  String currency;
  String status;

  phonePe_PaymentModel(
      {required this.custId,
      required this.amount,
      required this.note,
      required this.custName,
      required this.custPhone,
      required this.merchantId,
      required this.currency,
      required this.status});
}

class phonePe_Payment with ChangeNotifier {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('PhonePe_Transaction');
  String cmpnyCode = "THR";
  Future addTransaction(phonePe_PaymentModel paymentData) async {
    DateTime now = DateTime.now();
    String id = "";
    DocumentReference docRef = await collectionReference.add({
      "custId": paymentData.custId,
      "TransactionId": "",
      "custName": paymentData.custName,
      "amount": paymentData.amount,
      "note": paymentData.note,
      "date": now,
      "custPhone": paymentData.custPhone,
      "merchantId": paymentData.merchantId,
      "currency": paymentData.currency,
      "status": paymentData.status,
    });

    id = cmpnyCode + "_" + docRef.id.toUpperCase();
    docRef.update({
      "TransactionId": id,
    });
    return id;
  }

  Future updatePaymentbyTransactionId(
      String id, String status, var data) async {
    print("============");
    print(status);
    print(data);
    var transaction =
        await collectionReference.where("TransactionId", isEqualTo: id).get();

    if (transaction.docs.isNotEmpty) {
      var docId = transaction.docs.first.id;

      await collectionReference
          .doc(docId)
          .update({"status": status, "payment_responce": data});
    }
    // print(querySnapshot.docs[0]);
    return;
  }
}
