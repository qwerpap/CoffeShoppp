import 'package:flutter/material.dart';
import 'screens/home.dart';

class CoffeShopApp extends StatelessWidget {
  const CoffeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 246, 239, 239),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
