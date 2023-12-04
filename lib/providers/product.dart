import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firbase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? id;
  final String? productName;
  final String? productCode;
  final String? description;
  final String? photoName;
  final String? photo;
  final String? category;
  final String? gram;
      final int? branch;

  ProductModel({
    @required this.id,
    @required this.productName,
    @required this.productCode,
    @required this.description,
    @required this.photoName,
    @required this.photo,
    @required this.category,
    @required this.gram,
    @required this.branch,
  });
}

class Product with ChangeNotifier {
  final firbase_storage.FirebaseStorage storage =
      firbase_storage.FirebaseStorage.instance;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('product');

  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> uploadFile(
    String filePath,
    String fileName,
    ProductModel productModel,
  ) async {
    File file = File(filePath);

    try {
      final Directory systemTempDir = Directory.systemTemp;

      firbase_storage.TaskSnapshot taskSnapshot =
          await storage.ref('products/$fileName').putFile(file);
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      await collectionReference.add({
        "photo": downloadUrl,
        "photoName": fileName,
        "productName": productModel.productName,
        "productCode": productModel.productCode,
        "description": productModel.description,
      });

      await storage.ref('products/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<List?> read(String category) async {
    QuerySnapshot querySnapshot;
    List userlist = [];
    try {
      querySnapshot = await collectionReference
          .where("category", isEqualTo: category)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "photoName": doc['photoName'],
            "photo": doc["photo"],
            "productName": doc["productName"],
            "productCode": doc["productCode"],
            "description": doc["description"],
            "gram": doc["gram"],
            "category": doc["category"],
            "branch": doc["branch"],
          };
          userlist.add(a);
        }
       
        return userlist;
      }
    } catch (e) {
      print(e);
    }
  }
}
