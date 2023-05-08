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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) => GestureDetector(
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