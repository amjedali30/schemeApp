import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './login_screen.dart';
import '../widgets/home_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/local_push_notification.dart';
import '../screens/transaction_screen.dart';
import '../widgets/home_view.dart';
import 'googlemap_screen.dart';
import '../screens/gold_rate_screen.dart';
import '../screens/googlemap_rmntkr_screen.dart';
import '../screens/permission_message.dart';
import '../providers/goldrate.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime timeBackPress = DateTime.now();
  int _selectedIndex = 0;
  bool? _checkValue;
  AndroidNotificationChannel? channel;
  var buttonSize = const Size(50.0, 50.0);
  var buttonSize2 = const Size(30.0, 30.0);
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  String appBarName = "Thrissur Golden Jewellers";
  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() {
        appBarName = "Thrissur Golden Jewellers";
      });
    }
    if (index == 1) {
      setState(() {
        appBarName = "Maps";
        print("appBar");
      });
    }

    if (index != 3) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        // 'This channel is used for important notifications.', // description
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin!
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel!);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Goldrate? db;

  initialise() {
    db = Goldrate();

    db!.initiliase();

    db!.checkPermission().then((value) => {
          if (value == false)
            {
              Navigator.pushReplacementNamed(
                context,
                PermissionMessage.routeName,
              ),
            }
        });
  }

  @override
  void initState() {
    initialise();
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });

    requestPermission();
    loadFCM();
    listenFCM();
    // getToken();
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) => print(token));
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin!.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel!.id,
              channel!.name,
              // channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("user granted provisional permission");
    } else {
      print('user declained or has not accepted permission');
    }
  }

  @override
  void didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _checkValue = prefs.containsKey('user');
  }

  Widget? pageCaller(int index) {
    switch (index) {
      case 0:
        {
          return HomeView();
        }
      case 1:
        {
          return GoogleMapScreen();
        }

      case 2:
        {
          return GoldRateScreen();
        }
    }
  }

  redirectLoginPage() {
    if (_checkValue == true) {
      Navigator.of(context).pushNamed(TransactionScreen.routeName);
    } else {
      Navigator.of(context).pushNamed(LoginScreen.routeName);
    }
  }

  showCompanyTermsModel() {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      // context and builder are
      // required properties in this widget
      context: context,
      builder: (BuildContext context) {
        // we set up a container inside which
        // we create center column and display text

        // Returning SizedBox instead of a Container
        return SingleChildScrollView(
          child: SizedBox(
            height: 1200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'അൽഫിയ സ്വർണ സമ്പാദ്യ പദ്ധതി',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          " 500 രൂപ മുതൽ നിങ്ങൾക്ക് സ്വർണം സ്വന്തമാക്കാം.",
                          maxLines: 6,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle_notifications,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          "എന്താണ് അൽഫിയ സ്വർണ സാമ്പാദ്യ പദ്ധതി?",
                          maxLines: 5,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Text(
                    "നിങ്ങൾക്ക് ആഴ്ചയിലോ രണ്ടാഴ്ചയിലോ മാസത്തിലോ ചെറിയ തുകകൾ ആയി പണം നിക്ഷേപിച്ചു സ്വർണം സ്വന്തമാക്കാവുന്ന ഒരു സമ്പാദ്യ പദ്ധതി ആണ് അൽഫിയ സ്വർണ സമ്പാദ്യ പദ്ധതി",
                    maxLines: 5,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle_notifications,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          "എങ്ങനെ ഈ പദ്ധതിയിൽ അംഗമാകാം?",
                          maxLines: 5,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Text(
                    "500 രൂപ നൽകി കൊണ്ട് നിങ്ങൾക്ക് ഈ പദ്ധതിയിൽ അംഗമാവാം",
                    maxLines: 5,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle_notifications,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          "അൽഫിയ സ്വർണ സമ്പാദ്യ പദ്ധതിയിൽ അംഗമായാലുള്ള നേട്ടങ്ങൾ എന്തൊക്കെ?",
                          maxLines: 5,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Text(
                    "അൽഫിയ സ്വർണ സമ്പാദ്യ പദ്ധതിയിൽ അംഗമായാൽ നിങ്ങൾക്ക് ചെറിയ ചെറിയ തുകകൾ നിക്ഷേപിച്ചു കൊണ്ട് സ്വർണം സ്വന്തമാക്കാം.",
                    maxLines: 5,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.donut_small,
                              size: 18,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(
                                "500 രൂപ നൽകി കൊണ്ട് നിങ്ങൾക്ക് ഈ പദ്ധതിയിൽ അംഗമാവാം",
                                maxLines: 5,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.donut_small,
                              size: 18,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(
                                "പദ്ധതിയുടെ കാലാവധി ആയ 2 വർഷം പൂർത്തീകരിച്ചാൽ നിങ്ങൾക് നിങ്ങൾ നിക്ഷേപിച്ച തുകക്ക് പണികൂലി ഒന്നും തന്നെ ഇല്ലാതെ സ്വർണം വാങ്ങാം...",
                                maxLines: 5,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.donut_small,
                              size: 18,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(
                                "പദ്ധതി കാലാവധി (രണ്ട് വർഷം) ആകുന്നതിനു മുമ്പ് തന്നെ നിങ്ങൾക്ക് വേണമെകിൽ ചെറിയ പണി കൂലി മാത്രം നൽകി കൊണ്ട് സ്വർണാഭരണം വാങ്ങാം",
                                maxLines: 5,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.donut_small,
                              size: 18,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(
                                "ഇനി നിങ്ങൾക്ക് ആഭരണം വേണ്ട പണം തന്നെ തിരികെ മതി എങ്കിൽ നിങ്ങളുടെ പണം മുഴുവനായും തിരികെ ലഭിക്കുന്നതാണ്.",
                                maxLines: 5,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.donut_small,
                              size: 18,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(
                                "കൂടാതെ പദ്ധതി കാലയളവിൽ അൽഫിയ ജ്വല്ലറിയിൽ നിന്നും വാങ്ങുന്ന മറ്റു ആഭരണങ്ങൾക്കും വിവാഹ ആഭരണങ്ങൾക്കും കുറഞ്ഞ പണി കൂലി മാത്രം നൽകിയാൽ മതി.",
                                maxLines: 5,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle_notifications,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          "എത്രയാണ് ഈ പദ്ധതിയുടെ കാലാവധി ?",
                          maxLines: 5,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Text(
                    "2 വർഷം    (കാലാവധി തീരും മുമ്പ് തന്നെ നിങ്ങൾക്ക് വേണമെങ്കിൽ ചെറിയ പണി കൂലി മാത്രം നൽകി കൊണ്ട് സ്വർണം പർച്ചേഴ്സ് ചെയ്യാവുന്നതാണ്...)കാലാവധി പൂർത്തീകരിച്ചാൽ പണി കൂലി ഒട്ടും ഇല്ലാതെ സ്വർണം വാങ്ങാവുന്നതാണ്...",
                    maxLines: 5,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle_notifications,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          "സ്വർണം വേണ്ട പണം തന്നെ മതി എങ്കിൽ പണം തന്നെ തിരികെ ലഭിക്കുമോ?",
                          maxLines: 5,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Text(
                    "തീർച്ചയായും, നിങ്ങൾ നിക്ഷേപിച്ച മുഴുവൻ തുകയും നിങ്ങൾക്ക് തിരികെ പണമായി ലഭിക്കുന്നതാണ്...(കാലാവധി തീരണമെന്നില്ല)",
                    maxLines: 5,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle_notifications,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          " പണം എങ്ങനെ നിക്ഷേപിക്കും? ",
                          maxLines: 5,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Text(
                    "നിങ്ങൾക്ക് അൽഫിയ ആപ്പ് മുഖനെയോ അല്ലങ്കിൽ ഞങ്ങളുടെ അടുത്തുള്ള സ്ഥാപനം മുഖനെയോ പണം നിക്ഷേപിക്കാവുന്നതാണ്.",
                    maxLines: 10,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final diff = DateTime.now().difference(timeBackPress);
        final isExitWarning = diff >= Duration(seconds: 2);
        timeBackPress = DateTime.now();
        if (isExitWarning) {
          final snackBar =
              SnackBar(content: const Text("Press back again to exit"));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // final message = ;
          // Fluttertoast.showToast(msg: message, fontSize: 18);
          return false;
        } else {
          // Fluttertoast.cancel();
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    showCompanyTermsModel();
                  },
                  child: Icon(
                    FontAwesomeIcons.fileContract,
                    color: Colors.white,
                  ),
                ),
              ),
            ], // centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            title: Container(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Image.asset(
                    'assets/images/splashs.png',
                    fit: BoxFit.contain,
                    height: 100,
                  ),
                ),
              ),
            ),
            // centerTitle: true,
          ),
          body: pageCaller(_selectedIndex),
          floatingActionButton: _selectedIndex != 1
              ? SpeedDial(
                  icon: Icons.contact_page,
                  buttonSize: buttonSize,
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Theme.of(context).primaryColor,
                  children: [
                      SpeedDialChild(
                        child: const FaIcon(
                          FontAwesomeIcons.phone,
                          color: Colors.white,
                          size: 15,
                        ),
                        // label: 'Call',
                        backgroundColor: Color(0xFF3DDC84),
                        onTap: () async {
                          await launch("tel://+919562489889");
                          // _phoneNumberDialog(context);
                        },
                      ),
                      SpeedDialChild(
                        child: const FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                          size: 26,
                        ),
                        // label: 'Whatsapp',
                        backgroundColor: Color(0xFF25D366),
                        onTap: () async {
                          await launch(
                              "https://wa.me/+919562489889?text=Hello...");
                          // _whatsappDialog(context);
                        },
                      ),
                    ])
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: BottomAppBar(
            //bottom navigation bar on scaffold
            color: Colors.white,
            shape: CircularNotchedRectangle(), //shape of notch
            notchMargin:
                5, //notche margin between floating button and bottom appbar
            child: Row(
              //children inside bottom appbar
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.home,
                      size: 23,
                      color: _selectedIndex == 0
                          ? Theme.of(context).primaryColor
                          : Colors.black54),
                  onPressed: () {
                    _onItemTapped(0);
                  },
                ),
                SizedBox(
                  width: 25,
                ),
                SpeedDial(
                    icon: FontAwesomeIcons.mapMarkerAlt,
                    buttonSize: buttonSize2,
                    backgroundColor: Colors.white,
                    children: [
                      SpeedDialChild(
                        label: "Muvattupuzha",
                        child: const FaIcon(
                          FontAwesomeIcons.mapLocation,
                          color: Colors.white,
                          size: 25,
                        ),
                        // label: 'Call',
                        backgroundColor: Theme.of(context).primaryColor,
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(GoogleMapScreen.routeName);

                          // GoogleMapScreen();
                        },
                      ),
                    ]),
                // IconButton(
                //   icon: FaIcon(FontAwesomeIcons.mapMarkerAlt,
                //       size: 26,
                //       color: _selectedIndex == 1
                //           ? Theme.of(context).primaryColor
                //           : Colors.black54),
                //   onPressed: () {
                //     _onItemTapped(1);
                //   },
                // ),
                SizedBox(
                  width: 25,
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.userCircle,
                      size: 25,
                      color: _selectedIndex == 2
                          ? Theme.of(context).primaryColor
                          : Colors.black54),
                  onPressed: () {
                    _onItemTapped(3);
                    redirectLoginPage();
                    // Navigator.of(context).pushNamed(LoginScreen.routeName);
                  },
                ),
                //  SizedBox(width: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _phoneNumberDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 150,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Phone Number",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.red,
                        )),
                  ],
                ),
                Divider(
                  height: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                        icon: Icon(Icons.phone),
                        onPressed: () async {
                          await launch("tel://+91 9562489889");
                        },
                        label: Text("+91  95 6248 9889")),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // whats app dialoge

  Future<void> _whatsappDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 150,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Whatsapp Number",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.red,
                        )),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        icon: Icon(FontAwesomeIcons.whatsapp),
                        onPressed: () async {
                          await launch(
                              "https://wa.me/+91 9562489889?text=Hello...");
                        },
                        label: Text("+91 9562 489889")),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 2,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
