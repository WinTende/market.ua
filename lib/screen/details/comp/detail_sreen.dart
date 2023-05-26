import 'package:firebase/model/products.dart';
import 'package:firebase/screen/details/comp/body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Product product;

  const DetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: product.color,
      appBar: AppBar(
        backgroundColor: product.color,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Body(product: product),
    );
  }
}
