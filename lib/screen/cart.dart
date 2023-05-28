import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _scanBarcode = '';
  String _storeName = '';
  String _cardCode = '';
  String _selectedImage = '';
  late User? _user;
  bool _showBarcode = false;
  String _selectedCardId = '';

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    getUser();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = user;
    });
  }

  Future<void> _addCard() async {
    if (_user != null) {
      final userRef =
      FirebaseFirestore.instance.collection('user').doc(_user!.uid);
      final bonusCartRef = userRef.collection('bonus_cart');

      _storeName = '';
      _cardCode = '';
      _selectedImage = '';

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text('Додати картку'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Назва картки',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _storeName = value;
                          });
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Код картки',
                        ),
                        controller: TextEditingController(text: _cardCode),
                        onChanged: (value) {
                          setState(() {
                            _cardCode = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      Text('Оберіть зображення:'),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          _buildImageOption('atb.webp', setState),
                          _buildImageOption('fora.webp', setState),
                          _buildImageOption('silpo.webp', setState),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          _buildImageOption('fozzy.webp', setState),
                          _buildImageOption('mega.webp', setState),
                          _buildImageOption('novus.webp', setState),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Сканувати картку'),
                    onPressed: () async {
                      String barcodeScanRes =
                      await FlutterBarcodeScanner.scanBarcode(
                        '#ff6666',
                        'Cancel',
                        true,
                        ScanMode.BARCODE,
                      );

                      setState(() {
                        _cardCode = barcodeScanRes;
                      });
                    },
                  ),
                  TextButton(
                    child: Text('Відміна'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Додати'),
                    onPressed: () async {
                      final existingCardQuery = await bonusCartRef
                          .where('storeName', isEqualTo: _storeName)
                          .limit(1)
                          .get();

                      if (existingCardQuery.size > 0) {
                        final existingCardDoc = existingCardQuery.docs[0];
                        final existingCardId = existingCardDoc.id;

                        final cardData = {
                          'storeName': _storeName,
                          'cardCode': _cardCode,
                          'cardImage': _selectedImage,
                        };

                        await bonusCartRef.doc(existingCardId).update(cardData);
                      } else {
                        final cardData = {
                          'storeName': _storeName,
                          'cardCode': _cardCode,
                          'cardImage': _selectedImage,
                        };

                        await bonusCartRef.add(cardData);
                      }

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Помилка'),
            content: Text('Користувач не увійшов до системи.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildImageOption(String imageName, Function setState) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedImage = imageName;
          });
        },
        child: Container(
          height: 80,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(
              color: _selectedImage == imageName ? Colors.blue : Colors.grey,
              width: 2,
            ),
          ),
          child: Image.asset('assets/$imageName'),
        ),
      ),
    );
  }

  Future<void> _deleteCard(String cardId) async {
    final userRef =
    FirebaseFirestore.instance.collection('user').doc(_user!.uid);
    final bonusCartRef = userRef.collection('bonus_cart');

    await bonusCartRef.doc(cardId).delete();
  }

  Widget _buildBarcodeWidget(String cardCode) {
    return Center(
      child: Column(
        children: [
          BarcodeWidget(
            barcode: Barcode.code39(),
            data: cardCode,
            width: 350,
            height: 200,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            cardCode,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('user')
                      .doc(_user!.uid)
                      .collection('bonus_cart')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Виникла помилка: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return AnimationConfiguration.staggeredList(
                        position: 0,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Text(
                              'Немає доданих карток.',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      );
                    }

                    return AnimationLimiter(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final DocumentSnapshot document =
                          snapshot.data!.docs[index];
                          final cardId = document.id;
                          final storeName = document['storeName'];
                          final cardCode = document['cardCode'];
                          final cardImage = document['cardImage'];

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Card(
                                  child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        _selectedCardId = cardId;
                                        _showBarcode = true;
                                      });
                                    },
                                    leading: Image.asset('assets/$cardImage'),
                                    title: Text(storeName),
                                    subtitle: Text(cardCode),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                              Text('Подтвердите удаление'),
                                              content: Text(
                                                  'Ви впевнені, що хочете видалити цю картку?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Відміна'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Видалити'),
                                                  onPressed: () {
                                                    _deleteCard(cardId);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              if (_showBarcode)
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('user')
                      .doc(_user!.uid)
                      .collection('bonus_cart')
                      .doc(_selectedCardId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Виникла помилка: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Text('Каркта більше не існує.');
                    }

                    final DocumentSnapshot document = snapshot.data!;
                    final cardCode = document['cardCode'];

                    return _buildBarcodeWidget(cardCode);
                  },
                ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCard,
        tooltip: 'Додати картку',
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мої бонусні картки',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Мої бонусні картки'),
    );
  }
}