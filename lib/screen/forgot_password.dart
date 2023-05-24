import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  late AnimationController animationController;
  late Animation<double> animation;
  bool isResetting = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.lightBlueAccent,
      centerTitle: true,
      title: Text(
        'Reset Password',
        style: TextStyle(
          fontSize: 25,
          color: Colors.white,
        ),
      ),
    ),
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.lightBlueAccent],
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 170),
                    child: AnimatedDefaultTextStyle(
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pacifico',
                      ),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: Text(
                        'Enter your email\n to reset password',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 30,
                    ),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
                        prefixIcon: Icon(Icons.lock_reset),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.black12,
                            width: 2.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      autovalidateMode:
                      AutovalidateMode.onUserInteraction,
                      validator: (emailController) =>
                      emailController != null &&
                          !EmailValidator.validate(emailController)
                          ? 'Enter a valid email'
                          : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isResetting ? null : () => resetPassword(),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future resetPassword() async {
    setState(() {
      isResetting = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Email Sent'),
          content: Text('A password reset email has been sent to your email address.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Navigator.of(context).pop();
    } finally {
      setState(() {
        isResetting = false;
      });
    }
  }
}
