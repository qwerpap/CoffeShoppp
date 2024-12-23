import 'package:flutter/material.dart';
import 'product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onRemoveFromCart;
  final int cartQuantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.cartQuantity,
    required this.onIncrease,
    required this.onDecrease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            child: Image.asset(product.image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 15),
          Text(
            product.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          cartQuantity > 0
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: onDecrease,
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          cartQuantity.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        IconButton(
                          onPressed: onIncrease,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 13, right: 13, top: 2),
                  child: ElevatedButton(
                    onPressed: onAddToCart,
                    child: Text('${product.price} ₽'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
        ],
      )
    );
  }
}

