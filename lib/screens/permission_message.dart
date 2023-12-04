import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class PermissionMessage extends StatelessWidget {
  static const routeName = '/permission-screen';
  const PermissionMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5, left: 55, right: 55),
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    // color: ,
                    child: Image.asset(
                      'assets/images/denied.png',
                      fit: BoxFit.contain,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Text(
              "your account has been suspended",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 17,
                color: Colors.blue.shade900,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "for activate your account please contact",
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Thrissur Golden Jewellers administrator",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 37.0,
                  width: 70.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    child: Icon(
                      FontAwesomeIcons.whatsapp,
                      size: 24,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await launch(
                          "https://wa.me/+91 8891441921?text=Hello Sir, I can't access my application.");
                    },
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  height: 37.0,
                  width: 70.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    child: FaIcon(
                      FontAwesomeIcons.phone,
                      color: Colors.white,
                      size: 17,
                    ),
                    onPressed: () async {
                      await launch("tel://4952419921");
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
