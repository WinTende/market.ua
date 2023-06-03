import 'dart:async';
import 'package:firebase/screen/home_page.dart';
import 'package:firebase/screen/register.dart';
import 'package:firebase/screen/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class LogoAnimation extends StatefulWidget {
  @override
  _LogoAnimationState createState() => _LogoAnimationState();
}

class _LogoAnimationState extends State<LogoAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: ScaleTransition(
        scale: _animation,
        child: Image.asset(
          'assets/icons/logo.png',
          height: 200,
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3366FF),
              Color(0xFF00CCFF),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoAnimation(),
            SizedBox(height: 50),
            SpinKitFadingCube(
              color: Colors.white,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  static final String title = 'Market.ua';

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: title,
      home: FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 2000)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          } else {
            return MainPage();
          }
        },
      ),
    );
  }
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
          return VerifyEmail();
        }
        else{
          return RegPage();
        }


      },
    ),

  );


}