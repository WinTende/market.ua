import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/products.dart';

class ItemCard extends StatefulWidget {
  final Product product;
  final Function press;
  const ItemCard({
    Key? key,
    required this.product,
    required this.press
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
        final cardHeight = 180.0;
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
                height: 180,
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
                child: Image.asset(widget.product.image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                widget.product.title,
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
