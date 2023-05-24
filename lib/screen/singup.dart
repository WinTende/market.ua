import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SingUp extends StatefulWidget {
  final Function() onClickSingIn;

  const SingUp({
    Key? key,
    required this.onClickSingIn,
  }) : super(key: key);

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool IsLogin = true;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
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
          'Register',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 0),
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
                        child: TextFormField(
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (emailController) =>
                          emailController != null &&
                              !EmailValidator.validate(emailController)
                              ? 'Enter a valid email'
                              : null,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (password) =>
                          password != null && password.length < 6
                              ? 'Enter min 6 characters'
                              : null,
                        ),
                      ),
                      if (errorText != null)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            errorText!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(right: 15)),
                        ],
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
                                        onPressed: signUp,
                                        label: const Text('Confirm'),
                                        icon: const Icon(Icons.add),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.greenAccent,
                                          textStyle: const TextStyle(fontSize: 18),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          minimumSize: Size(200, 40), // Устанавливаем ширину кнопки
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
                      const SizedBox(height: 340),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              text: "Have an account? ",
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = widget.onClickSingIn,
                                  text: 'Login',
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
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        errorText = e.message;
      });
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
