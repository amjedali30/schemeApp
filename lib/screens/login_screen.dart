import 'package:flutter/material.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login-screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return SafeArea(
      child: Scaffold(
        appBar: isIOS == true
            ? AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              )
            : null,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 5, left: 55, right: 55),
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        color: Theme.of(context).primaryColor,
                        child: Image.asset(
                          'assets/images/splashs.png',
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 50,
                ),
                LoginForm(),
                // SizedBox(height: MediaQuery.of(context).size.height/3.7,),
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
        ),
      ),
    );
  }
}
