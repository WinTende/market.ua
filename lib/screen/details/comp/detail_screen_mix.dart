import 'package:firebase/model/products.dart';
import 'package:firebase/screen/details/comp/body.dart';
import 'package:firebase/screen/details/comp/product_selected_price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../model/product_mix.dart';

class DetailSreenMix extends StatelessWidget {
  final ProductMix productmix;
  final int selectedShop;

  const DetailSreenMix({Key? key, required this.productmix, required this.selectedShop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      backgroundColor: productmix.color,
      appBar: AppBar(
        backgroundColor: productmix.color,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
      ),
      body: ProductPrice(productmix: productmix, selectedShop: selectedShop,),
    );
  }
}