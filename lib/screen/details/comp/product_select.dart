import 'package:flutter/material.dart';

import '../../../model/product_mix.dart';
import 'detail_screen_mix.dart';

class ProductSelectionPage extends StatefulWidget {
  final int selectedShop;

  ProductSelectionPage({required this.selectedShop});

  @override
  _ProductSelectionPageState createState() => _ProductSelectionPageState();
}

class _ProductSelectionPageState extends State<ProductSelectionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Выберите товар',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: Color(0xff7fd0fd),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.blue[100]!],
            ),
          ),
          child: GridView.builder(
            padding: EdgeInsets.all(16),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailSreenMix(
                          productmix: products[index],
                          selectedShop: widget.selectedShop,
                        ),
                      ),
                    );
                  },
                  child: ScaleTransition(
                      scale: _animation,
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: products[index].color,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        products[index].title,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 4,
                                              offset: Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Второе изображение

                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Image.asset(
                                        products[index].image2,
                                        width: 100,
                                        height: 120,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Image.asset(
                                        products[index].image,
                                        width: 100,
                                        height: 120,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )));
            },
          ),
        ));
  }
}
