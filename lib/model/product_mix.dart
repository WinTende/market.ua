import 'dart:ui';

import 'package:flutter/cupertino.dart';

// 0 - Drinks
// 1 - Fruits
// 2 - Snacks

class ProductMix {
  final String
  image,
      image2 ,
      title,
      description,
      uriMega ,
      uriNovus ,
      uriATB ,
      uriFozzy ,
      uriMega2 ,
      uriNovus2 ,
      uriATB2 ,
      uriFozzy2;
  final int id;
  final Color color , color2;


  ProductMix({
    required this.id,
    required this.color,
    required this.color2,
    required this.title,
    required this.description,
    required this.image,
    required this.image2,
    required this.uriATB,
    required this.uriNovus,
    required this.uriMega,
    required this.uriFozzy,
    required this.uriATB2,
    required this.uriNovus2,
    required this.uriMega2,
    required this.uriFozzy2,
  });


  static List<ProductMix> searchByTitle(String query) {
    List<ProductMix> results = [];
    for (var product in products) {
      if (product.title.toLowerCase().contains(query.toLowerCase())) {
        results.add(product);
      }
    }
    return results;
  }
  String get url => image; // Getter method to return the product's image URL
}

List<ProductMix> products = [
  ProductMix(
      id: 0,
      title: "Ром + Кола",
      description:
      "\"Ром Кола\" - слабоалкогольний мікс, що має освіжаючий смак, у якому переважають нотки тропічних та цитрусових фруктів. Коктейль користується популярністю завдяки простому рецепту, доступним інгредієнтам та універсальним смаковим характеристикам.",
      image: 'assets/capmor.webp',
      image2: 'assets/cola.webp',
      color: Color(0xFFE18B10),
    color2: Color(0xFFCA191F),
    uriATB: 'https://www.atbmarket.com/product/napij-07l-captain-morgan-original-spiced-gold-alkogolnij-na-osnovi-romu-35?search=captain%20morgan',
    uriNovus: 'https://novus.online/product/rom-capitan-morgan-spiced-gold-35-07l',
    uriMega: 'https://megamarket.ua/products/rom-captain-morgan-original-spiced-gold-35-07l',
    uriFozzy : 'https://fozzyshop.ua/ru/rom/2655-rom-captain-morgan-spiced-gold-5000299223017.html',
    uriATB2: 'https://www.atbmarket.com/product/napij-15-l-coca-cola-bezalkogolnij-silnogazovanij?search=coca',
    uriNovus2: 'https://novus.online/product/napij-gazovanij-coca-cola-15l',
    uriMega2: 'https://megamarket.ua/products/voda-coca-cola-15l-h24',
    uriFozzy2: 'https://fozzyshop.ua/ru/voda-sladkaya-gazirovannaya/12883-napitok-coca-cola-15l-5449000000439.html',
  ),
  ProductMix(
    id: 1,
    title: "Желе + Кола",
    description:
    "\"Ром Кола\" - слабоалкогольний мікс, що має освіжаючий смак, у якому переважають нотки тропічних та цитрусових фруктів. Коктейль користується популярністю завдяки простому рецепту, доступним інгредієнтам та універсальним смаковим характеристикам.",
    image: 'assets/yami.webp',
    image2: 'assets/cola.webp',
    color: Color(0xFFFDAAC0),
    color2: Color(0xFFA40E14),
    uriATB: 'https://www.atbmarket.com/product/cukerki-70-g-rosen-yummi-gummi-sour-belts-zelejni?search=%D0%B6%D0%B5%D0%BB%D0%B5%D0%B9',
    uriNovus: 'https://novus.online/product/tsukerky-roshen-yummi-gummi-twists-zheleyni-70h',
    uriMega: 'https://megamarket.ua/products/tsukerki-roshen-zhelejni-yummi-gummi-duo-mix-70g',
    uriFozzy: 'https://fozzyshop.ua/ru/konfety-ledency-marmelad/97881-konfety-roshen-yummi-gummi-twists-0250014834164.html',
    uriATB2: 'https://www.atbmarket.com/product/napij-15-l-coca-cola-bezalkogolnij-silnogazovanij?search=coca',
    uriNovus2: 'https://novus.online/product/napij-gazovanij-coca-cola-15l',
    uriMega2: 'https://megamarket.ua/products/voda-coca-cola-15l-h24',
    uriFozzy2: 'https://fozzyshop.ua/ru/voda-sladkaya-gazirovannaya/12883-napitok-coca-cola-15l-5449000000439.html',
  ),
  ProductMix(
    id: 1,
    title: "Кава + Молоко",
    description:
    "\"Кава з молоком\" - Кава з молоком - гарячий кавовий напій, який готується шляхом змішування порції кави з гарячим молоком.",
    image: 'assets/kava.webp',
    image2: 'assets/moloko.webp',
    color: Color(0xFFA95316),
    color2: Color(0xFFC0DFF9),
    uriATB: 'https://www.atbmarket.com/product/kava-95g-jacobs-monarch-rozcinna-sublimovana?search=jacobs%20monarch',
    uriNovus: 'https://novus.online/product/kava-rozchynna-yakobz-monarkh-6100h',
    uriMega: 'https://megamarket.ua/products/kava-rozchinna-jacobs-monarch-100-g-8711000513859',
    uriFozzy: 'https://fozzyshop.ua/ru/kofe-rastvorimyj/31329-kofe-rastvorimyj-jacobs-monarch-naturalnyj-sublimirovannyj-s-b-7622210324078.html',
    uriATB2: 'https://www.atbmarket.com/product/moloko-09-kg-agotinske-ultrapasterizovane-26',
    uriNovus2: 'https://novus.online/product/moloko-26-agotin-pl-900g',
    uriMega2: 'https://megamarket.ua/products/moloko-yagotinske-26-ultrapasterizovane-tetra-fino-900g',
    uriFozzy2: 'https://fozzyshop.ua/ru/moloko/86228-moloko-ultrapasterizovannoe-yagotinske-26-4823005208259.html',
  ),

];
