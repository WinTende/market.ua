import 'dart:async';

import 'package:firebase/screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';


class VarifyEmail extends StatefulWidget {
  const VarifyEmail({Key? key}) : super(key: key);

  @override
  State<VarifyEmail> createState() => _VarifyEmailState();
}

class _VarifyEmailState extends State<VarifyEmail> {
  bool isEmailVerified = false;
  bool canResentEmail = false;
  Timer? timer ;
  @override
  void initState(){
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified){
      sendVerifyEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
          (_) => checkEmailVerified(),

      );
    }
  }

  @override
  void dispose(){
    timer?.cancel();

    super.dispose();
  }
  Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if(isEmailVerified){
      timer?.cancel();
    }
  }
  Future sendVerifyEmail() async{
    try{
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResentEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResentEmail = true);
    } catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context)  => isEmailVerified
      ?HomePage()
      :Scaffold(
    appBar: AppBar(
      title: Text("Verify Email"),
      backgroundColor: Colors.black54,
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
        padding: EdgeInsets.only(top: 230),
        child: Stack(
          children: <Widget>[
            Text(
              '  Letter sent to email'  ,
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ],
        )
    ),
          SizedBox(height: 25,),
          ElevatedButton.icon (
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
              backgroundColor: Colors.white54,
            ),
              icon: Icon(Icons.email, size: 32,),
              label: Text("Resent Email",
              style: TextStyle(fontSize: 24),),
            onPressed: (){
              if(canResentEmail = true){
                sendVerifyEmail();
              }
            }

          ),
          SizedBox(height: 25,),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50 ,),
                backgroundColor: Colors.black12
              ),

              icon: Icon(Icons.arrow_back, size: 32,),
              label: Text("Back",
                style: TextStyle(fontSize: 24),),
              onPressed:() => FirebaseAuth.instance.signOut(),

          ),
        ]
  )]
  )
  )
  );
}
