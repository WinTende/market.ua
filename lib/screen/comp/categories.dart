import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  final List<String> categories;
  final int selectedIndex;
  final Function(int) onTap;

  const Category({
    Key? key,
    required this.categories,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Анимация прокрутки выбранной категории к центру
      _scrollController.animateTo(
        (widget.selectedIndex * 60).toDouble(), // 90 - ширина одной категории
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    return SizedBox(
        height: 25,
        child: ListView.builder(
        controller: _scrollController, // Добавлено
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index)  => GestureDetector(
          onTap: () => widget.onTap(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.categories[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.selectedIndex == index
                        ? Colors.black
                        : Colors.black.withOpacity(0.4),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 2,
                  width: 30,
                  color: widget.selectedIndex == index
                      ? Colors.black
                      : Colors.transparent,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}