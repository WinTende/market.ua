import 'package:firebase/screen/home.dart';
import 'package:firebase/screen/home_page.dart';
import 'package:firebase/screen/login.dart';
import 'package:firebase/screen/register.dart';
import 'package:firebase/screen/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  static final String title = 'Login';

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) => MaterialApp(
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    title: title,
    home: HomePage(),
  );
}
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context , snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError){
          return Center(child: Text('Somthing went wrong'));
        } else if(snapshot.hasData){
          return VarifyEmail();
        }
        else{
          return RegPage();
        }


      },
    ),

  );


}

