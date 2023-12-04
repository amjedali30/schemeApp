import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';

class UserModel {
  final String? id;
  final String? name;
  final String? custId;
  final String? phoneNo;
  final String? address;
  final String? place;
  final double? balance;
  final String? token;
  final double? totalGram;
  final int? branch;
  final DateTime? dateofBirth;
  final String? nominee;
  final String? nomineePhone;
  final String? nomineeRelation;
  final String? adharCard;
  final String? panCard;
  final String? pinCode;

  UserModel({
    @required this.id,
    @required this.name,
    @required this.custId,
    @required this.phoneNo,
    @required this.address,
    @required this.place,
    @required this.balance,
    @required this.token,
    @required this.totalGram,
    @required this.branch,
    @required this.dateofBirth,
    @required this.nominee,
    @required this.nomineePhone,
    this.nomineeRelation,
    @required this.adharCard,
    this.panCard,
    this.pinCode,
  });

  UserModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        custId = data['custId'],
        phoneNo = data['phonne_no'],
        address = data['address'],
        place = data['place'],
        balance = data['balance'],
        token = data['token'],
        totalGram = data['total_gram'],
        branch = data['branch'],
        dateofBirth = data['dateofBirth'],
        nominee = data['nominee'],
        nomineePhone = data['nomineePhone'],
        nomineeRelation = data['nomineeRelation'],
        adharCard = data['adharCard'],
        panCard = data['panCard'],
        pinCode = data['pinCode'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'custId': custId,
      'phone_no': phoneNo,
      'address': address,
      'place': place,
      'balance': balance,
      'token': token,
      'totalGram': totalGram,
      'branch': branch,
      'dateofBirth': dateofBirth,
      'nominee': nominee,
      'nomineePhone': nomineePhone,
      'nomineeRelation': nomineeRelation,
      'adharCard': adharCard,
      'panCard': panCard,
      'pinCode': pinCode,
    };
  }
}

class User with ChangeNotifier {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('user');
  CollectionReference collectionCmpnt =
      FirebaseFirestore.instance.collection('company_config');
  // Map<String, UserModel> _user = {};
  late List<UserModel> _user;
  late List<UserModel> user;

  set listStaff(List<UserModel> val) {
    _user = val;
    notifyListeners();
  }

  List<UserModel> get listUsers => _user;
  // Map<String, UserModel> get users {
  //   return {..._user};
  // }

  int get userCount {
    return _user.length;
  }

  // Future<void> create(UserModel userModel) async {
  //   try {
  //     print("inside create ");
  //     print(userModel.name);
  //     await collectionReference.add({
  //       'name': userModel.name,
  //       'cust_id': userModel.custId,
  //       'phone_no': userModel.phoneNo,
  //       'address': userModel.address,
  //       'place': userModel.place,
  //       'balance': userModel.balance,
  //       'timestamp': FieldValue.serverTimestamp()
  //     });
  //     notifyListeners();
  //     final newUser = UserModel(
  //       id: userModel.id,
  //       name: userModel.name,
  //       custId: userModel.custId,
  //       phoneNo: userModel.phoneNo,
  //       address: userModel.address,
  //       place: userModel.place,
  //     );

  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<List?> read() async {
    QuerySnapshot querySnapshot;
    List userlist = [];
    try {
      querySnapshot = await collectionReference.orderBy('timestamp').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "name": doc['name'],
            "custId": doc["custId"],
            "phoneNo": doc["phone_no"],
            "address": doc["address"],
            "place": doc["place"],
            "balance": doc['balance'],
            "totalGram": doc["total_gram"],
            "branch": doc['branch'],
            // // "dateofBirth": doc['dateofBirth'].toDate(),
            "nominee": doc['nominee'],
            "nomineePhone": doc['nomineePhone'],
            "nomineeRelation": doc['nomineeRelation'],
            "adharCard": doc['adharCard'],
            "panCard": doc['panCard'],
            "pinCode": doc['pinCode'],
          };
          userlist.add(a);
        }
        print(userlist);
        return userlist;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List?> readById(String userId) async {
    QuerySnapshot querySnapshot;
    List userlist = [];
    try {
      querySnapshot = await collectionReference.orderBy('timestamp').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          if (userId == doc.id) {
            Map a = {
              "id": doc.id,
              "name": doc['name'],
              "custId": doc["custId"],
              "phoneNo": doc["phone_no"],
              "address": doc["address"],
              "place": doc["place"],
              "balance": doc['balance'],
              "totalGram": doc["total_gram"],
              "branch": doc["branch"],
              //  "dateofBirth": doc['dateofBirth'].toDate(),
              "nominee": doc['nominee'],
              "nomineePhone": doc['nomineePhone'],
              "nomineeRelation": doc['nomineeRelation'],
              "adharCard": doc['adharCard'],
              "panCard": doc['panCard'],
              "pinCode": doc['pinCode'],
              "customerType": doc["customerType"]
            };
            userlist.add(a);
          }
        }

        return userlist;
      }
    } catch (e) {
      print(e);
    }
  }

  void removeItem(String productId) {
    _user.remove(productId);
    notifyListeners();
  }

  void clear() {
    _user = [];
    notifyListeners();
  }

  Future getinsta() async {
    List cmdData = [];
    QuerySnapshot querySnapshot = await collectionCmpnt.get();
    for (var doc in querySnapshot.docs.toList()) {
      Map a = {
        "id": doc.id,
        "fb": doc['fb'],
        "insta": doc["insta"],
        "website": doc["website"]
      };
      cmdData.add(a);
    }
    return cmdData;
  }
}
