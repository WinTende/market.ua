import 'dart:async';
import 'package:firebase/screen/home_page.dart';
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
  runApp(MyApps());
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
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 200).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/icons/logo.png',
            height: _animation.value,
          ),
        ],
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
              Color(0xFFFFFFFF),
              Color(0xBB42E4FF),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // выравниваем по верху
          children: [
            SizedBox(height: 50), // добавляем пространство между верхней частью экрана и логотипом
            LogoAnimation(),
            Spacer(), // добавляем пространство между логотипом и индикатором загрузки
            CircularProgressIndicator(),
            Spacer(), // добавляем пространство между индикатором загрузки и нижней частью экрана
          ],
        ),
      ),
    );
  }
}

class MyApps extends StatelessWidget {
  static final String title = 'Login';

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) => MaterialApp(
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    title: title,
    home: FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 800)), // здесь мы задаем время отображения SplashScreen
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        } else {
          return HomePage();
        }
      },
    ),
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

