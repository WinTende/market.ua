import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'forgot_password.dart';

class AutherPage extends StatefulWidget {
  final VoidCallback onClickSingUp;
  const AutherPage({
    Key? key,
    required this.onClickSingUp,
}) : super(key: key);
  @override
  State<AutherPage> createState() => _AutherPageState();
}
class _AutherPageState extends State<AutherPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool IsLogin = true;
  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: Text('Login', style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(
            color: Colors.black87
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
                                    ..color = Colors.white54,
                                ),
                              ),
                              // Solid text as fill.
                              Text(
                                'Market.ua',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40, vertical: 30),

                        child: TextField(
                          style: TextStyle(color: Colors.white54),
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            prefixIcon: Icon(Icons.email),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.greenAccent,
                                width: 2.5,),),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.green,
                                width: 3.0,
                              ),
                            ),

                            hintText: 'Enter your email',
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: TextField(
                          style: TextStyle(color: Colors.white54),
                          controller: passwordController,
                          obscureText: true,

                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            prefixIcon: Icon(Icons.password),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.greenAccent,
                                width: 2.5,),),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.green,
                                width: 3.0,
                              ),
                            ),
                            hintText: 'Enter your password',
                          ),
                        ),
                      ),
                      SizedBox(height: 15,)

                    ]
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

                    SizedBox(height: 20,),
                    Row(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(width: 5),
                        FloatingActionButton.extended(

                          backgroundColor: Colors.transparent,
                          onPressed: signIn,
                          label: const Text('            Confirm                 '),
                          icon: const Icon(Icons.add),
                          focusColor: Colors.greenAccent,

                        ),
                      ],
                    ),
                    SizedBox(height: 300,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [GestureDetector(
                        child: Text('Forgot Password ?',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 20
                          ),
                        ),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ForgotPassword()
                        )),

                      )],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20
                              ),
                              text: "No accout?",
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = widget.onClickSingUp,
                                  text: 'Sing Up',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Theme.of(context).colorScheme.secondary
                                  ),

                                )
                              ]
                          )
                      ),],
                    )

                  ],

                ),

              ]

          ),

        )
    );

  }
  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator() ,
        ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch(e){
      print(e);
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
