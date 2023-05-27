import 'dart:ui';
import 'package:firebase/screen/comp/body.dart';
import 'package:firebase/screen/details/comp/sales_page.dart';
import 'package:firebase/screen/details/comp/toolbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'details/comp/map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  bool isToolbarVisible = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _slideAnimation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    final gradient = LinearGradient(
      colors: [Colors.white, Colors.blue],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    void onTap(int index) {
      setState(() {
        selectedIndex = index;
        isToolbarVisible = false;

        if (selectedIndex == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Toolbar()),
          );
        }
      });
    }

    void toggleToolbarVisibility() {
      setState(() {
        isToolbarVisible = !isToolbarVisible;
        if (isToolbarVisible) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    }

    Future<void> signOut() async {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut(); // Выход из аккаунта Google
    }

    Widget buildToolbar() {
      return Positioned(
        top: 0,
        bottom: 0,
        left: _slideAnimation.value,
        width: 75,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[200]!, Colors.blue[400]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 75),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                ),
                child: IconButtonWithText(
                  icon: Icon(Icons.credit_card_rounded, color: Colors.white),
                  text: 'Картки',
                  onPressed: () {
                    // Действия для просмотра профиля
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                ),
                child: IconButtonWithText(
                  icon: Icon(Icons.map, color: Colors.white),
                  text: 'Мапа',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapPage()),
                    );
                  },
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                ),
                child: IconButtonWithText(
                  icon: Icon(Icons.logout, color: Colors.white),
                  text: 'Выйти',
                  onPressed: signOut, // Вызов метода signOut()
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Stack(
          children: [
            Body(),
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return buildToolbar();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
                BottomNavigationBarItem(icon: Icon(Icons.percent_rounded), label: 'Скидки'),
              ],
              onTap: onTap,
              currentIndex: selectedIndex,
              selectedItemColor: Colors.blue, // Цвет активного элемента
              unselectedItemColor: Colors.grey,
            ),
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width / 2 - 20, // Размещаем кнопку в середине
            child: FloatingActionButton(
              onPressed: toggleToolbarVisibility,
              child: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _animationController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IconButtonWithText extends StatelessWidget {
  final Icon icon;
  final String text;
  final VoidCallback onPressed;

  const IconButtonWithText({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          IconButton(
            icon: icon,
            onPressed: onPressed,
          ),
          SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14, // Измените размер шрифта по вашему усмотрению
              fontWeight: FontWeight.bold, // Добавьте стиль шрифта по вашему усмотрению
            ),
          ),
        ],
      ),
    );
  }
}
