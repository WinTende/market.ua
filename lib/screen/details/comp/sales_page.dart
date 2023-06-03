import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../home_page.dart';
import 'map_page.dart';

class SalesPage extends StatefulWidget {
  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage>
    with SingleTickerProviderStateMixin {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String productName = '';
  late AnimationController _animationController;
  late Animation<double> _animation;
  int selectIndex = 1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
    productName = 'Sales Page';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Stream<List<Map<String, dynamic>>> fetchProducts() {
    return firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  double calculateDiscountPercentage(
      dynamic price1, dynamic price2, dynamic price3, dynamic price4) {
    final doublePrice1 = double.tryParse(price1?.toString() ?? '');
    final doublePrice2 = double.tryParse(price2?.toString() ?? '');
    final doublePrice3 = double.tryParse(price3?.toString() ?? '');
    final doublePrice4 = double.tryParse(price4?.toString() ?? '');
    if (doublePrice1 != null &&
        doublePrice2 != null &&
        doublePrice3 != null &&
        doublePrice4 != null) {
      final highestPrice = [
        doublePrice1,
        doublePrice2,
        doublePrice3,
        doublePrice4
      ].reduce((value, element) => value > element ? value : element);
      final lowestPrice = [
        doublePrice1,
        doublePrice2,
        doublePrice3,
        doublePrice4
      ].reduce((value, element) => value < element ? value : element);

      final priceDifference = highestPrice - lowestPrice;
      final priceDifferencePercentage = (priceDifference / highestPrice) * 100;
      return priceDifferencePercentage.isNaN ? 0 : priceDifferencePercentage;
    }

    return 0;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            productName.isNotEmpty ? productName : 'Sales Page',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blueAccent, // Цвет AppBar
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.1),
        ),
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFBBDEFB),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: fetchProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  final products = snapshot.data ?? [];
                  final filteredProducts = products.where((product) {
                    final doublePrice1 =
                    double.tryParse(product['ATB']?.toString() ?? '');
                    final doublePrice2 =
                    double.tryParse(product['Fozzy']?.toString() ?? '');
                    final doublePrice3 = double.tryParse(
                        product['MegaMarket']?.toString() ?? '');
                    final doublePrice4 =
                    double.tryParse(product['Novus']?.toString() ?? '');

                    if (doublePrice1 != null &&
                        doublePrice2 != null &&
                        doublePrice3 != null &&
                        doublePrice4 != null) {
                      final highestPrice = [doublePrice1, doublePrice2].reduce(
                              (value, element) =>
                          value > element ? value : element);
                      final lowestPrice = [
                        doublePrice1,
                        doublePrice2,
                        doublePrice3,
                        doublePrice4
                      ].reduce((value, element) =>
                      value < element ? value : element);

                      final priceDifference = highestPrice - lowestPrice;
                      final priceDifferencePercentage =
                          (priceDifference / highestPrice) * 100;
                      return priceDifferencePercentage >= 10;
                    }
                    return false;
                  }).toList();

                  if (filteredProducts.isEmpty) {
                    return Center(
                      child: Text('No products found.'),
                    );
                  }

                  filteredProducts.sort((a, b) {
                    final doublePriceA = double.tryParse(a['Novus']?.toString() ?? '') ?? 0;
                    final doublePriceB = double.tryParse(b['Novus']?.toString() ?? '') ?? 0;
                    return doublePriceB.compareTo(doublePriceA);
                  });


                  return ListView.builder(

                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        final title = product['title'] ?? 'Unknown Product';
                        final atbPrice = product['ATB'] ?? 'N/A';
                        final fozzyPrice = product['Fozzy'] ?? 'N/A';
                        final megaMarketPrice = product['MegaMarket'] ?? 'N/A';
                        final novusPrice = product['Novus'] ?? 'N/A';
                        final silpoPrice = product['Silpo'] ?? 'N/A';
                        final foraPrice = product['Fora'] ?? 'N/A';
                        final discountPercentage = calculateDiscountPercentage(
                            novusPrice, megaMarketPrice, atbPrice, fozzyPrice);
                        final imageUrl =
                            product['imageUrl'] ?? 'assets/default-image.jpg';
                        final colorString = product['color'] ?? '0xffe21f6f';
                        final colorHex = colorString
                            .replaceAll('Color(', '')
                            .replaceAll(')', '');
                        final color = Color(int.parse(colorHex));

                        return FadeTransition(
                          opacity: _animation,
                          child: Card(
                            elevation: 4,
                            margin: EdgeInsets.all(8),
                            shadowColor: Colors.black.withOpacity(0.2),
                            color: color,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  imageUrl,
                                  fit: BoxFit.fill,
                                  height: 150,
                                ),
                                ListTile(
                                  title: Text(
                                    title.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ATB: $atbPrice UAH',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Fozzy: $fozzyPrice UAH',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'MegaMarket: $megaMarketPrice UAH',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Novus: $novusPrice UAH',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Silpo: $silpoPrice UAH',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Fora: $foraPrice UAH',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  trailing: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${discountPercentage.toStringAsFixed(2)}% off',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                })));
  }
}
