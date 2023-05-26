import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Product {
  final String image, title, description, uriMega, uriNovus, uriATB, uriFozzy;
  final int id, category;
  final Color color;

  Product({
    required this.id,
    required this.category,
    required this.color,
    required this.title,
    required this.description,
    required this.image,
    required this.uriATB,
    required this.uriNovus,
    required this.uriMega,
    required this.uriFozzy,
  });

  static Future<List<Product>> getProducts() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('products_base').get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      return Product(
        id: data!['id'],
        category: data['category'],
        color: Color(data['color']),
        title: data['title'],
        description: data['description'],
        image: data['image'],
        uriATB: data['uriATB'],
        uriNovus: data['uriNovus'],
        uriMega: data['uriMega'],
        uriFozzy: data['uriFozzy'],
      );
    }).toList();
  }

  static void sortProductsByCategory(List<Product> products) {
    products.sort((a, b) => a.category.compareTo(b.category));
  }

  static List<Product> getProductsByCategory(
      List<Product> products, int categoryIndex) {
    if (categoryIndex == 0) {
      return products;
    } else {
      return products
          .where((product) => product.category == categoryIndex - 1)
          .toList();
    }
  }

  static List<Product> searchByTitle(List<Product> products, String query) {
    List<Product> results = [];
    for (var product in products) {
      if (product.title.toLowerCase().contains(query.toLowerCase())) {
        results.add(product);
      }
    }
    return results;
  }

  String get url => image;
}