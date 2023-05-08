import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../model/product_mix.dart';
import '../../../model/products.dart';
import 'package:html/parser.dart' as parser;


class ProductPrice extends StatefulWidget {
  final ProductMix productmix;
  final int selectedShop;

  const ProductPrice({Key? key, required this.productmix, required this.selectedShop}) : super(key: key);

  @override
  _ProductPriceState createState() => _ProductPriceState();
}

class _ProductPriceState extends State<ProductPrice> with SingleTickerProviderStateMixin {
  String _priceATB = '';
  String _priceATB2 = '';
  List<Widget> images = [];
  List<Widget> imageShop = [];
  List<String> pricesShop =["0", "0"];
  late AnimationController _controller;
  late Animation<double> _animation;


  @override
  void initState() {
    super.initState();
    fetchPrices();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: false);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    imageShop = [
      Image.asset('assets/atb.webp'),
      Image.asset('assets/novus.webp'),
      Image.asset('assets/varus.webp'),
      Image.asset('assets/fozzy.webp')
    ];
    images = widget.selectedShop == 0
        ? [imageShop[2]]
        : widget.selectedShop == 1
        ? [imageShop[3]]
        : widget.selectedShop == 2
        ? [imageShop[1]]
        : [imageShop[0]];
  }


  Future<void> fetchPrices() async {
    final uri = widget.selectedShop == 0 ? widget.productmix.uriVarus :
    widget.selectedShop == 1 ? widget.productmix.uriNovus :
    widget.selectedShop == 2 ? widget.productmix.uriFozzy :
    widget.productmix.uriATB;

    final uri2 = widget.selectedShop == 0 ? widget.productmix.uriVarus2 :
    widget.selectedShop == 1 ? widget.productmix.uriNovus2 :
    widget.selectedShop == 2 ? widget.productmix.uriFozzy2 :
    widget.productmix.uriATB2;
    await fetchPrice(uri, (price) {
      _priceATB = price!;
      pricesShop[0] = price;
    });
    await fetchPrice(uri2, (price) {
      _priceATB2 = price!;
      pricesShop[1] = price;
    });
  }

  Future<void> fetchPrice(String uri, void Function(String?) updatePrice) async {
    try {
      final response = await http.get(Uri.parse(uri));
      final document = parser.parse(response.body);
      final priceElement = document.querySelector(getPriceSelector());
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
        updatePrice(price);
        _animation = Tween<double>(
          begin: 0,
          end: double.parse(price ?? '0'),
        ).animate(_controller);
        _controller.reset();
        _controller.forward();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  String getPriceSelector() {
    switch (widget.selectedShop) {
      case 0:
        return '.sf-price__regular, .sf-price__special';
      case 1:
        return '.product-card__price-current';
      case 2:
        return '.current-price, .product-price';
      case 3:
        return '.product-price__top';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    double sum = (double.tryParse(pricesShop[0]) ?? 0) + (double.tryParse(pricesShop[1]) ?? 0);
    String formattedSum = sum.toStringAsFixed(2);
    List<String> titleParts = widget.productmix.title.split(' + ');
    List<String> productList = [];
    for (int i = 0; i < titleParts.length; i++) {
      productList.addAll(titleParts[i].split(' '));
    }
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
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
                        child: TyperAnimatedTextKit(
                          isRepeatingAnimation: false,
                          text: [widget.productmix.description],
                          textStyle: TextStyle(fontSize: 22.0),
                          speed: Duration(milliseconds: 30),
                          pause: Duration(milliseconds: 1000),
                          displayFullTextOnTap: true,
                          repeatForever: false,
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: pricesShop.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                              child: InkWell(
                                onTap: () {
                                  String url = '';
                                  switch (widget.selectedShop) {
                                    case 0:
                                      url = index == 0 ? widget.productmix.uriVarus : widget.productmix.uriVarus2;
                                      break;
                                    case 1:
                                      url = index == 0 ? widget.productmix.uriNovus : widget.productmix.uriNovus2;
                                      break;
                                    case 2:
                                      url = index == 0 ? widget.productmix.uriFozzy : widget.productmix.uriFozzy2;
                                      break;
                                    case 3:
                                      url = index == 0 ? widget.productmix.uriATB : widget.productmix.uriATB2;
                                      break;
                                  }
                                  if (url != null) {
                                    launch(url);
                                  }
                                },

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      children: images,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        ' ${productList[index]}',
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
                        textStyle: TextStyle(color: Colors.white,),
                        speed: Duration(milliseconds: 400),
                        pause: Duration(milliseconds: 1000),
                        displayFullTextOnTap: true,
                        repeatForever: false,
                      ),
                      TyperAnimatedTextKit(
                        isRepeatingAnimation: false,
                        text: [widget.productmix.title],
                        textStyle: TextStyle(fontSize: 24.0 , color: Colors.white , fontWeight: FontWeight.bold),
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
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: "Price\n"),
                                TextSpan(
                                  text: pricesShop.isEmpty
                                      ? 'Loading...'
                                      : '$formattedSum UAH',
                                  style: Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Image.asset(
                                      widget.productmix.image2,
                                      width: 150,
                                      height: 300,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                      widget.productmix.image,
                                      width: 130,
                                      height: 300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }}