import 'package:firebase/screen/details/comp/sales_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../home_page.dart';
import '../../login.dart';
import 'map_page.dart';

class Toolbar extends StatefulWidget {
  const Toolbar({Key? key}) : super(key: key);

  @override
  State<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> with SingleTickerProviderStateMixin {
  int selectedIndex = 1;
  bool isToolbarVisible = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut(); // Выход из аккаунта Google

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AutherPage(onClickSingUp: () {  },)),
    );
  }
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

    void onTap(int index) {
      setState(() {
        selectedIndex = index;
        isToolbarVisible = false;

        if (selectedIndex == 0) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HomePage()),
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

    Widget buildToolbar() {
      return Positioned(
        top: 0,
        bottom: 0,
        left: _slideAnimation.value,
        width: 75,
        child: Container(
          color: Colors.blue[200], // Цвет тулбара
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 75),
              SizedBox(height: 10),
              IconButtonWithText(
                icon: Icon(Icons.favorite, color: Colors.white),
                text: 'Избранное',
                onPressed: () {
                  // Действия для просмотра избранного
                },
              ),
              SizedBox(height: 10),
              IconButtonWithText(
                icon: Icon(Icons.visibility, color: Colors.white),
                text: 'Отслеживаемое',
                onPressed: () {
                  // Действия для просмотра отслеживаемого
                },
              ),
              SizedBox(height: 10),
              IconButtonWithText(
                icon: Icon(Icons.person, color: Colors.white),
                text: 'Профиль',
                onPressed: () {
                  // Действия для просмотра профиля
                },
              ),
              SizedBox(height: 10),
              IconButtonWithText(
                icon: Icon(Icons.map, color: Colors.white),
                text: 'Мапа',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapPage()),
                  );
                },
              ),
              Spacer(),
              IconButtonWithText(
                icon: Icon(Icons.logout, color: Colors.white),
                text: 'Выйти',
                onPressed: signOut,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SalesPage(),
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return buildToolbar();
            },
          ),
        ],
      ),
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
              BottomNavigationBarItem(icon: Icon(Icons.percent_rounded), label: 'Скидки'),
            ],
            onTap: onTap,
            currentIndex: selectedIndex,
            selectedItemColor: Colors.blue, // Цвет активного элемента
            unselectedItemColor: Colors.grey,
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
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
