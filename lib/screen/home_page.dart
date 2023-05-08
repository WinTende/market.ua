import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'comp/body.dart';
import 'details/comp/map_page.dart';
import 'home.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    void onTap(int index) {
      setState(() {
        selectIndex = index;
        if (selectIndex == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MixPage()),
          );
        } else if (index == 2){
        Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MapPage(),
        ));
      }else  {
          selectIndex = index;
        }}
        );
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Головна'),
          BottomNavigationBarItem(icon: Icon(Icons.blender), label: 'Мікс'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Мапа'),
        ],
        onTap: onTap,
        currentIndex: selectIndex,
      ),
      body: Body(),
    );
  }
}
