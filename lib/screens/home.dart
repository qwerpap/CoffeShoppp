import 'package:flutter/material.dart';
import '../features/products.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Products(),
    );
  }
}