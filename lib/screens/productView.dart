import 'package:flutter/material.dart';
import '../providers/product.dart';

class SwapableProductView extends StatefulWidget {
  SwapableProductView({Key? key, this.category}) : super(key: key);
  String? category;

  @override
  State<SwapableProductView> createState() => _SwapableProductViewState();
}

class _SwapableProductViewState extends State<SwapableProductView> {
  var categoryName;
  List productList = [];
  Future getCategory() async {
    setState(() {
      categoryName = widget.category;
    });
    print(categoryName);
    var db = Product();
    db.initiliase();
    db.read(categoryName).then((value) => {
          setState(() {
            productList = value!;
          })
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("${categoryName}".toUpperCase()),
        ),
        body: PageView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Card(
                  child: Container(
                    width: double.infinity,
                    height: 550,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 400,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                image:
                                    NetworkImage(productList[index]["photo"]),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                              child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Row(
                                //   children: [
                                //     Text(
                                //       " Product Name :    ",
                                //       style: TextStyle(
                                //           fontSize: 15,
                                //           fontWeight: FontWeight.w500),
                                //     ),
                                //     Text(
                                //       productList[index]["productName"],
                                //       style: TextStyle(
                                //           fontSize: 15,
                                //           fontWeight: FontWeight.w500),
                                //     ),
                                //   ],
                                // ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Code :      ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      productList[index]["productCode"],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Description :    ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(productList[index]["description"]),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Weight :      ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      productList[index]["gram"],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Branch :      ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "Moovatupuzha",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
              ));
            }));
  }
}
