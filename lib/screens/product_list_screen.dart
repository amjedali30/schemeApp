import 'package:flutter/material.dart';

import '../providers/category.dart';

import '../screens/productView.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductListScreen extends StatefulWidget {
  static const routeName = '/product-screen';
  ProductListScreen({Key? key, this.category}) : super(key: key);
  String? category;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool isSelect = true;
  var selectItem = [];
  Stream? products;
  Product? db;
  List userList = [];
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('product');

  Stream? _queryDb() {
    products = FirebaseFirestore.instance
        .collection('product')
        .where("category", isEqualTo: CategoryName)
        .snapshots()
        .map(
          (list) => list.docs.map((doc) => doc.data()),
        );
  }

  String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  String? CategoryName;
  initialise() {
    setState(() {
      CategoryName = widget.category;
    });

    db = Product();
    db!.initiliase();
    db!.read(CategoryName!).then((value) => {
          setState(() {
            userList = value!;
          })
        });
  }

  @override
  void initState() {
    _queryDb();
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            'Products',
          ),
        ),
        body: userList.isNotEmpty
            ?
            // body: StreamBuilder(
            //   stream: products,
            //   builder: (context, AsyncSnapshot snap) {
            //     List slideList = snap.data.toList();
            // if (snap.hasError) {
            //   return Text(snap.error);
            // }
            // if (snap.connectionState == ConnectionState.waiting) {
            //   return CircularProgressIndicator();
            // }
            // return
            GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.98),
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0,
                ),
                itemCount: userList.length,
                itemBuilder: (BuildContext context, int index) {
                  // final Map<String, dynamic> image = slideList[index];

                  return userList.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            print(userList[index]);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SwapableProductView(
                                          category: CategoryName!,
                                        )));
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 3,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 150,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          userList[index]["photo"],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Flexible(
                                      child: Text(
                                        userList[index]['productName'] != null
                                            ? capitalizeAllWord(
                                                userList[index]['productName'],
                                              )
                                            : userList[index]['productName'],
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: Text(
                                          "Branch  :",
                                          style: TextStyle(
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                      Container(
                                          child: Text("Moovatupuzha",
                                              style: TextStyle(
                                                fontSize: 10,
                                              ))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                  //   },
                  // );
                },
              )
            : Center(
                child: Text("No data found it this category...."),
              ));
  }
}
