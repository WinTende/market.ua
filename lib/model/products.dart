import 'dart:ui';

import 'package:flutter/cupertino.dart';

// 0 - Drinks
// 1 - Fruits
// 2 - Snacks

class Product {
  final String image, title, description ,uriMega , uriNovus , uriATB , uriFozzy;
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


  static List<Product> searchByTitle(String query) {
    List<Product> results = [];
    for (var product in products) {
      if (product.title.toLowerCase().contains(query.toLowerCase())) {
        results.add(product);
      }
    }
    return results;
  }
  String get url => image; // Getter method to return the product's image URL
}

List<Product> products = [
  Product(
    id: 0,
    title: "Pit Bull",
    description:
    "Pit Bull – безалкогольний напій з кофеїном, таурином, вітамінами та натуральними соками. Енергетична формула напою посилена натуральними екстрактами гуарани та даміани.",
    image: 'assets/pitbull.webp',
    category: 0,
    color: Color(0xFFE21F6F),
    uriATB: 'https://www.atbmarket.com/product/napij-1l-pit-bull-energeticnij?search=pit',
    uriNovus: 'https://novus.online/product/napij-bezalkogolnij-energeticnij-silnogazovanij-pit-bul-pet-1l',
    uriMega: 'https://megamarket.ua/products/napij-pit-bull-energetichnij-1l-h12',
      uriFozzy: 'https://fozzyshop.ua/ru/bezalkogolnye/3091-napitok-energeticheskij-pit-bull-4820097892786.html'
  ),
  Product(
    id: 1,
    title: "Red Bull",
    description:
    "Red Bull — енергетичний напій, виготовлений австрійською компанією Red Bull GmbH. Представлено у 173 країнах світу.",
    image: 'assets/prod_2.webp',
    category: 0,
    color: Color(0xFF33518E),
    uriATB: 'https://www.atbmarket.com/product/napij-355-ml-red-bull-energeticnij-zb',
    uriNovus: 'https://novus.online/product/napij-energeticnij-red-bull-0355l',
    uriMega: 'https://megamarket.ua/products/napij-red-bull-energetichnij-355ml-h24',
    uriFozzy : 'https://fozzyshop.ua/ru/bezalkogolnye/42604-napitok-energeticheskij-redbull-vkus-tropich-fruk-zhb-9002490231521.html',
  ),
  Product(
    id: 2,
    title: 'Lays 120 гр',
    color: Color(0xFFFDF113),
    category: 2,
    // Snacks
    image: 'assets/lays.webp',
    description:
    'Чіпси Lays виготовлені з картоплі преміум-класу та мають унікальний солонуватий та хрусткий смак, який подобається всім.',
    uriATB: 'https://www.atbmarket.com/product/cipsi120-g-lays-kartoplani-zi-smakom-smetani-ta-zeleni-mup?search=lays',
    uriNovus: 'https://novus.online/product/chipsy-kartoplyani-smak-smetany-i-zeleni-lays-120h',
    uriMega: 'https://megamarket.ua/products/chipsi-lays-barbekyu-135g',
    uriFozzy : 'https://fozzyshop.ua/ru/chipsy/54076-chipsy-lays-maxx-kartofelnye-so-vkusom-bezumnoj-salsy-120g-5900259095336.html',
  ),
  Product(
    id: 3,
    category: 1,
    color: Color(0xFFFBDF51),
    title: "Банани",
    description:
    "Бананы - це соковитий і смачний фрукт, який має безліч корисних властивостей для організму. Банани багаті калієм, який допомагає регулювати серцевий ритм та зміцнювати м'язи, а також містять вітаміни C та B6, які покращують імунну систему та допомагають підтримувати здоров'я нервової системи.",
    image: 'assets/banan.webp',
    uriATB: 'https://www.atbmarket.com/product/banan-1-gat',
    uriNovus: 'https://novus.online/product/banan-vag',
    uriMega: 'https://megamarket.ua/products/banani-ekvador-vagovi',
    uriFozzy : 'https://fozzyshop.ua/ru/frukty-i-yagody/11745-banan-2732485.html',
  ),
  Product(
    id: 4,
    title: "Моршинська",
    description:
    "«Моршинська» — це столова вода, із низьким рівнем мінералізації (0,1—0,3 г/л). Згідно з апробацією, яку 2004 року провів Інститут педіатрії, акушерства і гінекології АМН України, «Моршинська» негазована має склад, що дозволяє давати її немовлятам без будь-якої додаткової обробки.",
    image: 'assets/morsh.webp',
    category: 0,
    color: Color(0xFF2B82CC),
    uriATB: 'https://www.atbmarket.com/product/voda-15l-morsinska-mineralna-silnogazovana?search=%D0%BC%D0%BE%D1%80%D1%88',
    uriNovus: 'https://novus.online/product/voda-gazovana-morsinska-15l',
    uriMega: 'https://megamarket.ua/products/voda-mineralna-morshinska-ng-15l-h6',
    uriFozzy : 'https://fozzyshop.ua/ru/voda-mineralnaya-negazirovannaya/12796-voda-mineralnaya-morshinska-n-gaz-4820017000024.html',
  ),
  Product(
    id: 5,
    title: "Captain Morgan\n0.7 L",
    description:
    "Captain Morgan - марка рому, що виробляється британським алкогольним конгломератом Diageo. Названа на ім'я валлійського пірата, англійського капера, а пізніше плантатора та віце-губернатора Ямайки сера Генрі Моргана. 21 - 50% про. Найбільшими ринками збуту для Captain Morgan є США, Великобританія, Канада, Німеччина та ПАР.",
    image: 'assets/capmor.webp',
    category: 0,
    color: Color(0xFFD0781C),
    uriATB: 'https://www.atbmarket.com/product/napij-07l-captain-morgan-original-spiced-gold-alkogolnij-na-osnovi-romu-35?search=captain%20morgan',
    uriNovus: 'https://novus.online/product/rom-capitan-morgan-spiced-gold-35-07l',
    uriMega: 'https://megamarket.ua/products/rom-captain-morgan-original-spiced-gold-35-07l',
    uriFozzy : 'https://fozzyshop.ua/ru/rom/2655-rom-captain-morgan-spiced-gold-5000299223017.html',
  ),
  Product(
      id: 6,
      category: 0,
      color: Color(0xFF0087C9),
      title: 'Молоко',
      description: 'Ультрапастеризоване молоко ТМ «Яготинське» - це високоякісне натуральне молоко, яке випускається в надсучасній упаковці Тетра Пак і має термін зберігання до 180 діб.',
      image: 'assets/moloko.webp',
      uriATB: 'https://www.atbmarket.com/product/moloko-09-kg-agotinske-ultrapasterizovane-26',
      uriNovus: 'https://novus.online/product/moloko-26-agotin-pl-900g',
      uriMega: 'https://megamarket.ua/products/moloko-yagotinske-26-ultrapasterizovane-tetra-fino-900g',
      uriFozzy: 'https://fozzyshop.ua/ru/moloko/86228-moloko-ultrapasterizovannoe-yagotinske-26-4823005208259.html',
  ),
  Product(
    id: 7,
    category: 0,
    color: Color(0xFFEE2F37),
    title: 'Coca-Cola\n1.5 L',
    description: 'Coca-Cola — газированный безалкогольный напиток, производимый компанией Coca-Cola.',
    image: 'assets/cola.webp',
    uriATB: 'https://www.atbmarket.com/product/napij-15-l-coca-cola-bezalkogolnij-silnogazovanij?search=coca',
    uriNovus: 'https://novus.online/product/napij-gazovanij-coca-cola-15l',
    uriMega: 'https://megamarket.ua/products/voda-coca-cola-15l-h24',
    uriFozzy: 'https://fozzyshop.ua/ru/voda-sladkaya-gazirovannaya/12883-napitok-coca-cola-15l-5449000000439.html',
  ),
  Product(
    id: 8,
    category: 3,
    color: Color(0xFFFDEC00),
    title: 'Майонез\nКоролівський смак \n300g',
    description: 'Майонез "Королевский вкус" очень питателен - содержит много витаминов A. B1, B2, B3, E и PP и микроэлементов.',
    image: 'assets/may.webp',
    uriATB: 'https://www.atbmarket.com/product/majonez-300-g-korolivskij-smak-korolivskij-67?search=%D0%BC%D0%B0%D0%B9%D0%BE%D0%BD',
    uriNovus: 'https://novus.online/product/majoneznyj-sous-korolevskij-vkus-korolevskij-67-300g',
    uriMega: 'https://megamarket.ua/products/majonez-schedro-provansal-67-300g-h12',
    uriFozzy: 'https://fozzyshop.ua/ru/majonez/94730-majonez-korolivskij-smak-korolevskij-67-d-p-4820175669699.html',
  ),
  Product(
    id: 9,
    category: 4,
    color: Color(0xFFEC8746),
    title: 'Морозиво\n«Ласунка»',
    description: 'Морозиво від «Ласунка» - це завжди багато задоволення. А тепер задоволення ще й у великому стакані. Це морозиво припаде до смаку всім і мамам і дітям.',
    image: 'assets/stakan.webp',
    uriATB: 'https://www.atbmarket.com/product/morozivo-100g-lasunka-stakan-velikan-z-pidvarkami-abrikosova-ta-visneva?search=%D0%BC%D0%BE%D1%80%D0%BE%D0%B6%D0%B5%D0%BD%D0%BE%D0%B5',
    uriNovus: 'https://novus.online/product/morozivo-stakan-velikan-plombir-u-vafelnomu-stakani-lasunka-85g',
    uriMega: '0',
    uriFozzy: 'https://fozzyshop.ua/ru/morozhenoe/93830-morozhenoe-lasunka-malyuk-am-plombir-vafelnyj-stakan-4820193554335.html',
  ),
  Product(
    id: 10,
    category: 2,
    color: Color(0xFFFDCE4B),
    title: 'Yummi Gummi',
    description: 'Желейные конфеты Roshen Yummi Gummi Funny Cola — это микс желатиновых конфет в форме бутылок сладких газированных напитков со вкусом колы.',
    image: 'assets/yami.webp',
    uriATB: 'https://www.atbmarket.com/product/cukerki-70-g-rosen-yummi-gummi-sour-belts-zelejni?search=%D0%B6%D0%B5%D0%BB%D0%B5%D0%B9',
    uriNovus: 'https://novus.online/product/tsukerky-roshen-yummi-gummi-twists-zheleyni-70h',
    uriMega: 'https://megamarket.ua/products/tsukerki-roshen-zhelejni-yummi-gummi-duo-mix-70g',
    uriFozzy: 'https://fozzyshop.ua/ru/konfety-ledency-marmelad/97881-konfety-roshen-yummi-gummi-twists-0250014834164.html',
  ),
  Product(
    id: 11,
    category: 1,
    color: Color(0xFFD0E778),
    title: 'Авакадо',
    description: 'Авокадо - плід вічнозеленого дерева американська персея (Persea americana) сімейства лаврових (Lavraceae) з тропічної Америки. А ще авокадо називають алігаторовою грушею, alligator pear. Авокадо містить не менше 11 вітамінів та 14 мінералів. У ньому багато вітаміну Е – найважливішого з антиокислювачів.',
    image: 'assets/avacado.webp',
    uriATB: 'https://www.atbmarket.com/product/avokado-vagove-1-gat',
    uriNovus: 'https://novus.online/product/avokado-khaas-dribnyy-sht',
    uriMega: '0',
    uriFozzy: 'https://fozzyshop.ua/ru/frukty-i-yagody/11727-avokado-0250000398144.html',
  ),
  Product(
    id: 12,
    category: 0,
    color: Color(0xFFB75F27),
    title: 'Кава\nJacobs Monarch \n95г',
    description: 'Jacobs Monarch - натуральна сублімована кава, новинка на споживчому ринку. Новий рівень якості даної серії виріс завдяки покращеній технології екстракції, прискореній обробці при зниженій температурі. Аромат став насиченішим, багатшим, смак яскравішим.',
    image: 'assets/kava.webp',
    uriATB: 'https://www.atbmarket.com/product/kava-95g-jacobs-monarch-rozcinna-sublimovana?search=jacobs%20monarch',
    uriNovus: 'https://novus.online/product/kava-rozchynna-yakobz-monarkh-6100h',
    uriMega: 'https://megamarket.ua/products/kava-rozchinna-jacobs-monarch-100-g-8711000513859',
    uriFozzy: 'https://fozzyshop.ua/ru/kofe-rastvorimyj/31329-kofe-rastvorimyj-jacobs-monarch-naturalnyj-sublimirovannyj-s-b-7622210324078.html',
  ),
  Product(
    id: 13,
    category: 0,
    color: Color(0xFF346901),
    title: 'Пиво\nОболонь Світле \n0,5 л',
    description: 'Торгова марка пива «Оболонь» належить до київського ЗАТ «Оболонь». Представлений напій з легким, освіжаючим смаковим букетом. Смак пива Оболонь складає ненав\'язлива ячмінна насолода, яка гармонійно врівноважена легкою, округлою хмелевою гіркуватістю.',
    image: 'assets/pivo.webp',
    uriATB: 'https://www.atbmarket.com/product/pivo-05-l-obolon-svitle?search=%D0%BF%D0%B8%D0%B2%D0%BE%20%D0%BE%D0%B1%D0%BE%D0%BB%D0%BE%D0%BD%D1%8C',
    uriNovus: 'https://novus.online/product/pivo-svitle-obolon-45-05l-sklpl',
    uriMega: '0',
    uriFozzy: 'https://fozzyshop.ua/ru/pivo-svetloe/2919-pivo-obolon-svitle-svetloe-4820000191708.html',
  ),
];

void sortProductsByCategory() {
  products.sort((a, b) => a.category.compareTo(b.category));
}
List<Product> getProductsByCategory(int categoryIndex) {
  if (categoryIndex == 0) {
    return products;
  } else {
    return products.where((product) => product.category == categoryIndex - 1).toList();
  }
}