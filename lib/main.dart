import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import './providers/payment.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import './providers/goldrate.dart';
import './providers/transaction.dart';
import './providers/user.dart';
import './providers/product.dart';
import './service/local_push_notification.dart';
import './screens/home_screen.dart';
import './screens/transaction_screen.dart';
import 'screens/googlemap_screen.dart';
import './screens/login_screen.dart';
import './screens/gold_rate_screen.dart';
import './screens/product_list_screen.dart';
import './screens/payment_screen.dart';
import './screens/googlemap_rmntkr_screen.dart';
import './screens/permission_message.dart';
// import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarColor: Color(0xff212322), // status bar color
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => User(),
        ),
        ChangeNotifierProvider(
          create: (_) => Transaction(),
        ),
        ChangeNotifierProvider(
          create: (_) => Goldrate(),
        ),
        ChangeNotifierProvider(
          create: (_) => Product(),
        ),
        ChangeNotifierProvider(
          create: (_) => Payment(),
        ),
      ],
      child: MaterialApp(
          title: 'Preethi Gold Park',
          theme: ThemeData(
            // primarySwatch: buildMaterialColor(Color(0xFFc0a950)),
            primaryColor: Color(0xff212322),
            accentColor: Color(0xFFfacc88),
            fontFamily: 'Lato',
          ),
          debugShowCheckedModeBanner: false,
          // home: Splash(),
          home: AnimatedSplashScreen(
            splash: Image.asset('assets/images/splashs.png'),
            splashIconSize: 200,
            nextScreen: HomeScreen(),
            splashTransition: SplashTransition.scaleTransition,
            backgroundColor: Color(0xff212322),
            duration: 1000,
            //  Container(
            //   height: 400,
            //   width: 400,
            //   color: Color(0xFF612e3e),
            // ),
          ),
          routes: {
            TransactionScreen.routeName: (ctx) => TransactionScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            GoogleMapScreen.routeName: (ctx) => GoogleMapScreen(),
            GoldRateScreen.routeName: (ctx) => GoldRateScreen(),
            PaymentScreen.routeName: (ctx) => PaymentScreen(),
            ProductListScreen.routeName: (ctx) => ProductListScreen(),
            // GooglemapRmntkrScreen.routeName: (ctx) => GooglemapRmntkrScreen(),
            PermissionMessage.routeName: (ctx) => PermissionMessage(),
          }),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  _navigateHome() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff8a172e),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: AnimatedSplashScreen(
            backgroundColor: Color(0xff8a172e),
            splash: Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("assets/images/splashs.png"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            nextScreen: HomeScreen(),
          )),
    );
  }
}
