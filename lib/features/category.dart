import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  final Function(int) onCategorySelected;
  final int selectedIndex;

  const Category({
    Key? key,
    required this.onCategorySelected,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final List<String> categories = [
    'Кофе с молоком',
    'Черный кофе',
    'Американо',
    'Авторские напитки'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              widget.onCategorySelected(index);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color:
                    widget.selectedIndex == index ? Colors.blue : Colors.white,
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                      fontSize: 15,
                      color: widget.selectedIndex == index
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}