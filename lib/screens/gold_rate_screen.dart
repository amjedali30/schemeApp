import 'package:flutter/material.dart';

class GoldRateScreen extends StatelessWidget {
  static const routeName = '/gold-rate-screen';
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20, left: 55, right: 55),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 6,
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      children: [
                        Container(
                          color: Theme.of(context).primaryColor,
                          // padding: EdgeInsets.all(5),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                padding: EdgeInsets.all(5),
                                child: Image.asset('assets/images/logo.png'),
                              ),
                              Container(
                                color: Theme.of(context).primaryColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "  Rani  ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontFamily: 'Lato'),
                                    ),
                                    Text(
                                      " Jewellery",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          fontFamily: 'Lato',
                                          color: Colors.white70),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Hello",
                style: TextStyle(
                    fontFamily: 'latto', fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            // LoginForm(),
            SizedBox(height: MediaQuery.of(context).size.height/3.7,),
            // Container(
            //   height: 50,
            //   color:  Color(0xFFccccb3).withOpacity(0.3),
            //   padding: EdgeInsets.only(top: 10, bottom: 20,left: 18 ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       // Text("Powered by Lucid Craft",style: TextStyle(color: Colors.white60,fontSize: 12),),
            //       // FlatButton(onPressed: () {}, child: Text("Sign up here",style: TextStyle(fontFamily: 'latto',color: Colors.white),))
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
