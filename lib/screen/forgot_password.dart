import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
  appBar: AppBar(
  backgroundColor: Colors.black54,
  centerTitle: true,
  title: Text('Reset Password', style: TextStyle(
  fontSize: 25,
  color: Colors.white,
  ),
  ),
  ),
  body: Container(
  alignment: Alignment.center,
  padding: const EdgeInsets.all(32),
  decoration: const BoxDecoration(
  image: DecorationImage(
  image: AssetImage('assets/bac.jpg'),
  fit: BoxFit.cover,
  )
  ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,



          children: <Widget>[

      Column(


      children: <Widget>[
      Padding(
      padding: EdgeInsets.only(top: 170),
      child: Stack(
        children: <Widget>[
          Text(
            '  Enter your email\n to reset password',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ],
      )
  ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 40, vertical: 30),

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
                  width: 2.5,),),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Colors.white,
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
        Row(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(width: 5),
            // An example of the small floating action button.
            //
            // https://m3.material.io/components/floating-action-button/specs#669a1be8-7271-48cb-a74d-dd502d73bda4
            FloatingActionButton.extended(

              backgroundColor: Colors.white54,
              onPressed: () => ResetPassword(),

              label: const Text('            Confirm                 '),
              icon: const Icon(Icons.add),
              focusColor: Colors.greenAccent,
            ),
          ],
        ),
  ]
  )
  ]
  )
  )
  );
  Future ResetPassword() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator())
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Navigator.of(context).popUntil((route) => route.isFirst);

    } on FirebaseAuthException catch(e){
      print(e);
      Navigator.of(context).pop();

    }


  }
}
