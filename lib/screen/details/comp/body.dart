import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/products.dart';
import 'package:html/parser.dart' as parser;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Body extends StatefulWidget {
  final Product product;

  const Body({Key? key, required this.product}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  bool isLoading = true;
  List<String> shop = ['ATБ', 'Novus', 'MegaMarket', 'Fozzy'];
  List<String> pricesShop = ["0", "0", "0", "0"];
  List<Image> images = [
    Image.asset('assets/atb.webp'),
    Image.asset('assets/novus.webp'),
    Image.asset('assets/mega.webp'),
    Image.asset('assets/fozzy.webp')
  ];

  late AnimationController _controller;
  late Animation<double> _animation;
  double minPrice = 0;
  late FirebaseFirestore firestore;
  double getMinPrice() {
    final filteredPrices = pricesShop.where((price) => price != "0").toList();

    if (filteredPrices.isEmpty) {
      return 0;
    }

    final sortedPrices = filteredPrices.map((price) => double.parse(price)).toList()..sort();
    return sortedPrices.first;
  }
  @override
  void initState() {
    super.initState();
    fetchPrices();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    firestore = FirebaseFirestore.instance;

  }

  Future<void> fetchPrices() async {
    setState(() {
      isLoading = true;
    });
    await Future.wait([
      fetchPrice('ATB', widget.product.uriATB, 0),
      fetchPrice('Novus', widget.product.uriNovus, 1),
      fetchPrice('Fozzy', widget.product.uriFozzy, 3),
      fetchPrice('MegaMarket', widget.product.uriMega, 2),
    ]);
    setState(() {
      isLoading = false;
    });

    await saveTitle(widget.product.title, widget.product.image);
  }
  Future<void> saveTitle(String title, String imageUrl) async {
    final productRef = FirebaseFirestore.instance.collection('products').doc(widget.product.title);
    final documentSnapshot = await productRef.get();

    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      data!['title'] = title;
      data['imageUrl'] = imageUrl;
      data['id'] = widget.product.id;
      data['color'] = widget.product.color.toString(); // Add the "color" field
      await productRef.update(data);
    } else {
      await productRef.set({
        'title': title,
        'imageUrl': imageUrl,
        'id': widget.product.id,
        'color': widget.product.color.toString(), // Add the "color" field
      });
    }
  }

  Future<void> fetchPrice(String shopName, String uri, int index) async {
    try {
      final response = await http.get(Uri.parse(uri));
      final document = parser.parse(response.body);
      final priceElement = document.querySelector(getPriceSelector(shopName));
      var price = priceElement?.text.trim();
      final priceParts = price?.split('.');
      if (priceParts != null && priceParts.length == 2) {
        price = '${priceParts[0]}.${priceParts[1].padRight(2, '0')}';
      }
      price = price?.replaceAll(RegExp(r'[^\d.,]+'), '');
      if (price?.contains(',') == true) {
        price = price?.replaceAll(',', '.');
      }
      setState(() {
        pricesShop[index] = price!;
        print('$shopName - $price');
      });

      final productRef = FirebaseFirestore.instance.collection('products').doc(widget.product.title);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(productRef);
        if (snapshot.exists) {
          final data = snapshot.data();
          if (data != null) {
            final currentPrice = data[shopName];
            if (currentPrice != price) {
              data[shopName] = price;
              await transaction.update(productRef, data);
            }
          }
        } else {
          await transaction.set(productRef, {shopName: price});
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  String getPriceSelector(String shopName) {
    switch (shopName) {
      case 'ATB':
        return '.price';
      case 'Novus':
        return '.product-card__price-current';
      case 'MegaMarket':
        return '.price';
      case 'Fozzy':
        return '.current-price, .product-price';
      default:
        throw ArgumentError('Invalid shop name: $shopName');
    }
  }

  List<double> sortPrices(List<String> prices) {
    return prices.map((price) => double.parse(price)).toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    List<double> sortedPrices = sortPrices(pricesShop);
    Size size = MediaQuery.of(context).size;
    String description = widget.product.description;
    double minPrice = getMinPrice();
    // Определяем первые 10 слов описания
    String shortDescription = '';
    List<String> words = description.split(' ');
    if (words.length <= 10) {
      shortDescription = description;
    } else {
      shortDescription = words.sublist(0, 10).join(' ') + '...';
    }

    // Переключатель для полного/сокращенного описания
    bool isFullDescription = false;

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 1000),
      child: isLoading
          ? Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinKitFadingCube(
              color: Colors.white,
              size: 40.0,
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 300),
              child: ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/icons/logo.png',
                height: 200,
              ),
            ),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        child: AbsorbPointer(
          absorbing: isLoading,
          child: Stack(
              children: <Widget>[
                Positioned(
                  top: -70,
                  right: 10,
                  child: Image.asset(
                    'assets/loz.webp',
                    width: 200,
                    height: 200,
                    // Добавьте дополнительные свойства для позиционирования и размера изображения по вашему усмотрению.
                  ),
                ),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: size.height,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: size.height * 0.41),
                                  height: 700,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      topRight: Radius.circular(24),
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 20),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isFullDescription = !isFullDescription;
                                            });
                                          },
                                          child: Text(
                                            isFullDescription
                                                ? widget.product.description
                                                : shortDescription,
                                            style: TextStyle(fontSize: 22.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: pricesShop.length,
                                          itemBuilder: (context, index) {
                                            if (pricesShop[index] == "0") {
                                              // Пропустить, если цена не доступна
                                              return Container();
                                            }
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                              child: InkWell(
                                                onTap: () {
                                                  String url = "http://example.com";
                                                  if (index == 0) {
                                                    url = widget.product.uriATB;
                                                  } else if (index == 1) {
                                                    url = widget.product.uriNovus;
                                                  } else if (index == 2) {
                                                    url = widget.product.uriMega;
                                                  }
                                                  if (url != null) {
                                                    launch(url);
                                                  }
                                                },
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    images[index],
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        ' ${shop[index]}',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${pricesShop[index]} UAH',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      TyperAnimatedTextKit(
                                        isRepeatingAnimation: false,
                                        text: ['Товар'],
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        speed: Duration(milliseconds: 400),
                                        pause: Duration(milliseconds: 1000),
                                        displayFullTextOnTap: true,
                                        repeatForever: false,
                                      ),
                                      TyperAnimatedTextKit(
                                        isRepeatingAnimation: false,
                                        text: [widget.product.title],
                                        textStyle: TextStyle(
                                            fontSize: 24.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        speed: Duration(milliseconds: 300),
                                        pause: Duration(milliseconds: 1000),
                                        displayFullTextOnTap: true,
                                        repeatForever: false,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          AnimatedBuilder(
                                            animation: _animation,
                                            builder: (BuildContext context, Widget? child) {
                                              String price =
                                                  'Ціна \n${minPrice.toStringAsFixed(2)} UAH';
                                              return Text(
                                                price,
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            width: 60,
                                          ),
                                          Expanded(
                                              child: FadeTransition(
                                                opacity: _animation,
                                                child: Image.asset(
                                                  widget.product.image,
                                                  fit: BoxFit.fill,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    })],
            ),
          ),
        ),
      );
  }
}
