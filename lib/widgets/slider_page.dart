import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SliderPage extends StatefulWidget {
  const SliderPage({Key? key}) : super(key: key);

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  Stream? slides;

  Stream? _queryDb() {
    slides = FirebaseFirestore.instance.collection('slide').snapshots().map(
          (list) => list.docs.map((doc) => doc.data()),
        );
  }

  @override
  void initState() {
    _queryDb();
    super.initState();
  }

  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: slides,
        builder: (context, AsyncSnapshot snap) {
          // print("==========");
          // print();
          List slideList = snap.data.toList();
          if (snap.hasError) {
            return Text(snap.error.toString());
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return snap.data != null
              ? PageView.builder(
                  controller: controller,
                  itemCount: slideList.length,
                  itemBuilder: (context, int index) {
                    return _buildStoryPage(slideList[index]);
                  })
              : Container();
        },
      ),
    );
  }

  // _buildStoryPage(Map data) {
  //   return ClipRRect(
  //                     borderRadius: BorderRadius.circular(15),
  //                     child: Image.network(
  //                        data['photo'],
  //                      fit: BoxFit.cover,
  //                     ));
  // }

  _buildStoryPage(Map data) {
    return Container(
      child: CachedNetworkImage(
        imageUrl: data['photo'],
        placeholder: (context, url) => Image.asset(
          'assets/images/loadimage.gif',
          fit: BoxFit.cover,
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(1),
      //   image: DecorationImage(
      //     fit: BoxFit.cover,
      //     image:
      //      NetworkImage(
      //       data['photo'],
      //     ),
      //   ),
      // ),
      // child: Center(
      //   child: Text(data['name']),
      // ),
    );
  }
}
