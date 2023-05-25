import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:ui';

import 'forgot_password.dart';

class AutherPage extends StatefulWidget {
  final VoidCallback onClickSingUp;

  const AutherPage({Key? key, required this.onClickSingUp}) : super(key: key);

  @override
  State<AutherPage> createState() => _AutherPageState();
}

class _AutherPageState extends State<AutherPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = true;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  double buttonWidth = 200; // Ширина кнопки (можно изменить на необходимую)
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0),
      ),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Login',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Stack(
                    children: <Widget>[
                      // Stroked text as border.
                      Text(
                        'Market.ua',
                        style: TextStyle(
                          fontSize: 40,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 5
                            ..color = Colors.blue.shade100,
                        ),
                      ),
                      // Solid text as fill.
                      Text(
                        'Market.ua',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.blue.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      prefixIcon: Icon(Icons.email),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blueAccent.shade100,
                          width: 2.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                          width: 3.0,
                        ),
                      ),
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      prefixIcon: Icon(Icons.password),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blueAccent.shade100,
                          width: 2.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                          width: 3.0,
                        ),
                      ),
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(right: 15)),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(width: 10),
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (BuildContext context, Widget? child) {
                            return Transform.translate(
                              offset: _slideAnimation.value,
                              child: Opacity(
                                opacity: _opacityAnimation.value,
                                child: ElevatedButton.icon(
                                  onPressed: signIn,
                                  label: const Text('Confirm'),
                                  icon: const Icon(Icons.add),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.greenAccent,
                                    textStyle: const TextStyle(fontSize: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize:
                                    Size(buttonWidth, 40), // Устанавливаем ширину кнопки
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: 10),
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.translate(
                          offset: _slideAnimation.value,
                          child: Opacity(
                            opacity: _opacityAnimation.value,
                            child: ElevatedButton.icon(
                              onPressed: signInWithGoogle,
                              label: const Text('Sign in with Google'),
                              icon: const Icon(Icons.login),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                textStyle: const TextStyle(fontSize: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize:
                                Size(buttonWidth, 40), // Устанавливаем ширину кнопки
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
                SizedBox(height: 250),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        text: "No account?",
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickSingUp,
                            text: ' Sign Up',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // Добавляем данные аккаунта в базу данных Firestore
      final user = userCredential.user;
      if (user != null) {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        final userData = {
          'userId': userId,
          // Добавьте другие данные аккаунта, если необходимо
        };

        await FirebaseFirestore.instance
            .collection('user')
            .doc(userId)
            .set(userData);
      }
    } catch (e) {
      print(e);
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

}
