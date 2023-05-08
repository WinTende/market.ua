import 'package:firebase/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'details/comp/map_page.dart';
import 'details/comp/product_select.dart';

class MixPage extends StatefulWidget {
  @override
  _MixPageState createState() => _MixPageState();
}

class _MixPageState extends State<MixPage> with TickerProviderStateMixin {
  int _selectedIndex = 1;
  int selectedShop = -1;
  Color color1 = Color(0xff9ed8fc);
  Color color2 = Color(0xff1e1d1d);


  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      if (index == 1) {
        _controller.reset();
        _controller.forward();
      } else if (index == 0) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
      } else if (index == 2){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MapPage(),
        ));
      }
    }
  }

  Widget _buildStoreTile(String storeName, String imagePath,
      {required Function() onTap}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      color: color1,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                imagePath,
                height: 80,
              ),
              Text(
                storeName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Мікс Товарів",
            style: TextStyle(
              color: Colors.black26,
            ),
          ),
          backgroundColor: Colors.blue[100],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Головна'),
            BottomNavigationBarItem(icon: Icon(Icons.blender), label: 'Мікс'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Мапа'),
          ],
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
        ),
        body: FadeTransition(
            opacity: _animation,
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff7fd0fd),
                      Color(0xff29bfff),
                    ],
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Оберіть магазин',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                          child: ListView(
                              children: [
                                _buildStoreTile(
                                  'Varus',
                                  'assets/varus.webp',
                                  onTap: () {
                                    selectedShop = 0;
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductSelectionPage(
                                                selectedShop: selectedShop,
                                              ),
                                        ));
                                  },
                                ),
                                SizedBox(height: 10),
                                _buildStoreTile(
                                  'Novus',
                                  'assets/novus.webp',
                                  onTap: () {
                                    selectedShop = 2;
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductSelectionPage(
                                                selectedShop: selectedShop,
                                              ),
                                        ));
                                  },
                                ),
                                SizedBox(height: 10),
                                _buildStoreTile(
                                  'Fozzy',
                                  'assets/fozzy.webp',
                                  onTap: () {
                                    selectedShop = 1;
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductSelectionPage(
                                                selectedShop: selectedShop,
                                              ),
                                        ));
                                  },
                                ),
                                SizedBox(height: 10),
                                _buildStoreTile(
                                  'ATB',
                                  'assets/atb.webp',
                                  onTap: () {
                                    selectedShop = 3;
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductSelectionPage(
                                                selectedShop: selectedShop,
                                              ),
                                        ));
                                  },
                                )
                              ]
                          )
                      )
                    ])
            )));
  }}