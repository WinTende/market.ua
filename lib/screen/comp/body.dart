import 'package:firebase/model/products.dart';
import 'package:firebase/screen/details/comp/detail_sreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'categories.dart';
import 'item_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  BannerAd? _bannerAd;
  int _selectedIndex = 0;
  String _searchQuery = '';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-6636044014701516/4327668686',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print('Реклама загружена.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Не удалось загрузить рекламу: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Stack(children: [
      Container(
        alignment: Alignment.center,
        child: AdWidget(
          ad: _bannerAd!,
        ),
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
      ),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.blue[100]!,
            ],
          ),
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Пошук...',
                hintStyle: TextStyle(
                  color: Colors.black54,
                ),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          FadeTransition(
            opacity: _animation,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Категорії",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          FadeTransition(
            opacity: _animation,
            child: Category(
              categories: [
                'Усі товари',
                'Напої',
                'Фрукти',
                'Закуски',
                'Соуси',
                'Морозиво'
              ],
              selectedIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
          Expanded(
            child: FadeTransition(
              opacity: _animation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  itemCount: Product.searchByTitle(_searchQuery)
                      .where((product) =>
                  _selectedIndex == 0 ||
                      product.category == _selectedIndex - 1)
                      .length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    final filteredProducts = Product.searchByTitle(_searchQuery)
                        .where((product) =>
                    _selectedIndex == 0 ||
                        product.category == _selectedIndex - 1)
                        .toList();
                    return ItemCard(
                      product: filteredProducts[index],
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailSreen(
                              product: filteredProducts[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      )
    ]);
  }}