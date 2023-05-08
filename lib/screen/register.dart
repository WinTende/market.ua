import 'package:firebase/screen/singup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class RegPage extends StatefulWidget {

  @override
  State<RegPage> createState() => _RegPageState();
}


class _RegPageState extends State<RegPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) =>
    isLogin ?
    AutherPage(onClickSingUp: toggle)
        :SingUp(onClickSingIn: toggle);
  void toggle() => setState(() => isLogin = !isLogin);

}


