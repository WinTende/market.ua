import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/products.dart';

class ItemCard extends StatefulWidget {
  final Product product;
  final Function press;
  const ItemCard({
    Key? key,
    required this.product,
    required this.press,
  }) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        final animationValue = _opacityAnimation.value;
        final cardHeight = 200.0; // Увеличиваем высоту контейнера
        final cardWidth = 160.0;
        final cardOffsetY = (1 - animationValue) * cardHeight;

        return Opacity(
          opacity: animationValue,
          child: Transform.translate(
            offset: Offset(0, cardOffsetY),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          widget.press();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                height: 200, // Изменяем высоту контейнера
                width: 160,
                decoration: BoxDecoration(
                  color: widget.product.color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Image.network(
                  widget.product.image,
                  fit: BoxFit.contain, // Добавляем свойство fit для изображения
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                widget.product.title.replaceAll(r'\n', '\n'), // Замена символа "\n" на абзац
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}