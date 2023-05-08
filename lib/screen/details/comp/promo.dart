import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class Product {
  final String title;
  final String oldPrice;
  final String newPrice;
  final String imageUrl;
  final String websiteUrl;

  Product({
    required this.title,
    required this.oldPrice,
    required this.newPrice,
    required this.imageUrl,
    required this.websiteUrl,
  });
}

class ATBPage extends StatefulWidget {
  const ATBPage({Key? key}) : super(key: key);

  @override
  _ATBPageState createState() => _ATBPageState();
}

class _ATBPageState extends State<ATBPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('https://novus.online/promotion'));
    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final productElements = document.querySelectorAll('.base-card__label');
      final oldPriceElements = document.querySelectorAll('.base-card__price-old');
      final newPriceElements = document.querySelectorAll('.base-card__price-current');
      final imageElements = document.querySelectorAll('.base-image__img');

      int imageIndex = 36; // Начальная позиция для картинок

      for (var i = 0; i < productElements.length; i++) {
        final product = productElements[i].text.trim();
        final oldPrice = oldPriceElements[i].text.trim();
        final newPrice = newPriceElements[i].text.trim();
        String imageUrl = '';
        String websiteUrl = '';

        if (imageIndex < imageElements.length) {
          imageUrl = 'https://novus.online${imageElements[imageIndex].attributes['src']}';
          imageIndex++;
        } if(imageUrl == "https://novus.onlinenull" || imageUrl == 'https://novus.online/uploads/8/41554-badge.svg' || imageUrl == "https://novus.online/uploads/10/52750-15.svg" || imageUrl == "https://novus.online/uploads/10/52750-15.svg") {
          imageUrl = 'https://img4.zakaz.ua/store_logos/og_novus.jpeg';
        }

        final productElement = productElements[i];
        final anchorElement = document.querySelector('.base-is-link.base-card.catalog-products__item');
        if (anchorElement != null) {
          websiteUrl = 'https://novus.online${anchorElement.attributes['href']}';
        }

        print('Product: $product');
        print('Old Price: $oldPrice');
        print('New Price: $newPrice');
        print('Image URL: $imageUrl');
        print('Website URL: $websiteUrl');
        if (product.isNotEmpty && newPrice.isNotEmpty) {
          setState(() {
            products.add(Product(
              title: product,
              oldPrice: oldPrice,
              newPrice: newPrice,
              imageUrl: imageUrl,
              websiteUrl: websiteUrl,

            ));
          });
        }
      }
    } else {
      print('Не удалось получить информацию о товарах. Код состояния: ${response.statusCode}');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Акционные предложения ATB'),
        backgroundColor: Colors.green[800], // Цвет фона для шапки
      ),
      body: Container(
        padding: EdgeInsets.all(16.0), // Отступы для контейнера
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                launch(product.websiteUrl);
              },
              child: Card(
                elevation: 4.0, // Тень для карточки
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.network(
                        product.imageUrl,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/novus.webp'); // Replace with your local asset image path
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.all(16.0), // Отступы для контейнера
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(height: 8.0), // Расстояние между текстом
                            Text(
                              'Старая цена: ${product.oldPrice}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 8.0), // Расстояние между текстом
                            Text(
                              'Новая цена: ${product.newPrice}',
                              style: TextStyle(
                                color: Colors.green[800],
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ATBPage(),
  ));
}
