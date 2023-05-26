import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/products.dart';
import 'package:firebase/screen/details/comp/detail_sreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../model/ad_mob.dart';
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
  bool showFavoritesOnly = false;

  List<int> userFavorites = [];

  late StreamSubscription<QuerySnapshot> _favoritesSubscription;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
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
      adUnitId: AdMobService.bannerAdUnitId!,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print('Реклама загружена.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Не удалось загрузить рекламу: $error');
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();

    // Get the current user's ID
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      // Subscribe to changes in the user's favorites collection
      _favoritesSubscription = FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('favorite')
          .snapshots()
          .listen((snapshot) {
        setState(() {
          userFavorites = snapshot.docs.map((doc) => int.parse(doc.id)).toList();
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _favoritesSubscription.cancel(); // Cancel the stream subscription
    super.dispose();
  }

  Future<List<Product>> getFilteredProducts() async {
    List<Product> products = await Product.getProducts(); // Получение списка продуктов из базы данных

    if (showFavoritesOnly) {
      return Product.searchByTitle(products, _searchQuery)
          .where((product) =>
      userFavorites.contains(product.id) &&
          (_selectedIndex == 0 || product.category == _selectedIndex - 1))
          .toList();
    } else {
      return Product.searchByTitle(products, _searchQuery)
          .where((product) => _selectedIndex == 0 || product.category == _selectedIndex - 1)
          .toList();
    }
  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Stack(
      children: [
        // ...
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
                  hintText: 'Поиск...',
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
            Container(
              height: 50,
              width: 750, // Задайте желаемую высоту баннера
              child: AdWidget(ad: _bannerAd!),
            ),
            Row(
              children: [
                FadeTransition(
                  opacity: _animation,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Категории",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 190),
                  child: IconButton(
                    icon: Icon(
                      showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        showFavoritesOnly = !showFavoritesOnly;
                      });
                    },
                  ),
                ),
              ],
            ),
            FutureBuilder<List<Product>>(
              future: getFilteredProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Ошибка при загрузке данных'),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text('Нет данных'),
                  );
                } else {
                  final filteredProducts = snapshot.data!;
                  return FadeTransition(
                    opacity: _animation,
                    child: Category(
                      categories: [
                        'Все товары',
                        'Напитки',
                        'Фрукты',
                        'Закуски',
                        'Соусы',
                        'Мороженое',
                      ],
                      selectedIndex: _selectedIndex,
                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  );
                }
              },
            ),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: getFilteredProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Ошибка при загрузке данных'),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text('Нет данных'),
                    );
                  } else {
                    final filteredProducts = snapshot.data!;
                    return FadeTransition(
                      opacity: _animation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                          itemCount: filteredProducts.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                          ),
                          itemBuilder: (context, index) {
                            return ItemCard(
                              product: filteredProducts[index],
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      product: filteredProducts[index],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }}