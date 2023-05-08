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

class _SingUpState extends State<SingUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
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
          title: Text('Register', style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(
            color: Colors.black87,
          ),

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

                          child: TextFormField(
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (emailController) =>
                            emailController !=null && !EmailValidator.validate(emailController)
                                ? 'Enter a valid email'
                                :null,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(color: Colors.white54),

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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (password) =>
                            password !=null && password.length< 6
                                ? 'Enter min 6 characters'
                                :null,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 30),
                        ),

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
                      Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(width: 5),
                          // An example of the small floating action button.
                          //
                          // https://m3.material.io/components/floating-action-button/specs#669a1be8-7271-48cb-a74d-dd502d73bda4
                          FloatingActionButton.extended(

                            backgroundColor: Colors.transparent,
                            onPressed: signUp,

                            label: const Text('            Confirm                 '),
                            icon: const Icon(Icons.add),
                            focusColor: Colors.greenAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 350),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20
                                ),
                                text: "Have account ? ",
                                children: [
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = widget.onClickSingIn,
                                    text: 'Login',
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
          ),

        )
    );

  }
  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if(!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator() ,
      ),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch(e){
      print(e);

    }
    Navigator.of(context).popUntil((route) => route.isFirst);
}
}
