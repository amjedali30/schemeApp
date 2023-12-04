import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Providers/transaction.dart';

class TransactionList extends StatefulWidget {
  static const routeName = "/transaction_list";
  TransactionList({Key? key, required this.transaction, required this.type})
      : super(key: key);
  var transaction;
  String type;

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  var selectedIndex = -1;
  bool isClick = false;

  List transactionList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      transactionList = widget.transaction;
    });
    print("-------");
    print(transactionList);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: transactionList.length > 0
            ? Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: transactionList.length,
                    itemBuilder: (BuildContext context, int index) {
                      DateTime myDateTime =
                          (transactionList[index]['date']).toDate();

                      return GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                height: 35,
                                color: Colors.grey.shade300,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      DateFormat.yMMMd()
                                          // .add_jm()
                                          .format(myDateTime)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    )),
                              ),
                              Container(
                                color: Colors.white,
                                height: 70,
                                child: ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.only(right: 10),
                                    child: transactionList[index]
                                                ['transactionType'] ==
                                            0
                                        ? FaIcon(
                                            FontAwesomeIcons.plusCircle,
                                            size: 22,
                                            color: Colors.green[700],
                                          )
                                        : FaIcon(
                                            FontAwesomeIcons.minusCircle,
                                            size: 22,
                                            color: Colors.red[700],
                                          ),
                                  ),
                                  title: Text(
                                      "${transactionList[index]['note']}"
                                          .toUpperCase()),
                                  subtitle: Row(
                                    children: [
                                      Text("Invoice No : " +
                                          "${transactionList[index]['invoiceNo']}"
                                              .toUpperCase()),
                                    ],
                                  ),
                                  trailing: Text(
                                    " ₹ ${transactionList[index]['amount'].toString()}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "latto",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Colors.black12,
                              ),
                              Container(
                                  height: 40,
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 8, bottom: 8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.list_alt,
                                          color: Colors.grey.shade600,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "Transaction Details",
                                          style: TextStyle(
                                            fontFamily: 'latto',
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedIndex = index;
                                                    isClick = true;
                                                  });
                                                },
                                                child: isClick == false
                                                    ? Icon(Icons
                                                        .keyboard_arrow_down)
                                                    : GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedIndex = -1;
                                                            isClick = false;
                                                          });
                                                        },
                                                        child: Icon(Icons
                                                            .keyboard_arrow_up),
                                                      )),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                              selectedIndex == index
                                  ? Container(
                                      height: widget.type == "0" ? 180 : 50,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // Row(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.spaceBetween,
                                            //   children: [
                                            //     Text(
                                            //       "Category",
                                            //       style: TextStyle(
                                            //         fontFamily: 'latto',
                                            //         fontSize: 12,
                                            //         color: Colors.black87,
                                            //       ),
                                            //     ),
                                            //     Text(
                                            //       transactionList[index]
                                            //           ['category'],
                                            //       style: TextStyle(
                                            //         fontFamily: 'latto',
                                            //         fontSize: 12,
                                            //         color: Colors.black87,
                                            //       ),
                                            //     )
                                            //   ],
                                            // ),
                                            widget.type == "0"
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Gram Price",
                                                        style: TextStyle(
                                                          fontFamily: 'latto',
                                                          fontSize: 12,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      Text(
                                                        transactionList[index][
                                                                'gramPriceInvestDay']
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontFamily: 'latto',
                                                          fontSize: 12,
                                                          color: Colors.black87,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Container(
                                                    height: 1,
                                                  ),
                                            widget.type == "0"
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Gram Weight",
                                                        style: TextStyle(
                                                          fontFamily: 'latto',
                                                          fontSize: 12,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      Text(
                                                        transactionList[index]
                                                                ['gramWeight']
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontFamily: 'latto',
                                                          fontSize: 12,
                                                          color: Colors.black87,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Container(),
                                            Container(
                                              height: 1,
                                              color: Colors.black12,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Total Amount",
                                                  style: TextStyle(
                                                    fontFamily: 'latto',
                                                    fontSize: 12,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  " ₹ ${transactionList[index]['amount'].toString()}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: "latto",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                        ),
                      );
                    }))
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
      ),
    );
  }
}
