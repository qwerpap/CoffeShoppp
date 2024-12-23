import 'package:flutter/material.dart';

class Product {
  final String category;
  final String name;
  final String image;
  final int price;

  Product({
    required this.category,
    required this.name,
    required this.image,
    required this.price,
  });
}

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

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final ScrollController productScrollController = ScrollController();
  int selectedCategoryIndex = 0;
  final Map<Product, int> cart = {}; // Храним количество каждого товара

  final List<Product> productList = [
    Product(
        category: 'Кофе с молоком',
        name: 'Олеато',
        image: 'assets/coffe.png',
        price: 139),
    Product(
        category: 'Кофе с молоком',
        name: 'Капучино',
        image: 'assets/coffe.png',
        price: 159),
    Product(
        category: 'Черный чай',
        name: 'Греческий чай',
        image: 'assets/coffe.png',
        price: 99),
    Product(
        category: 'Черный чай',
        name: 'Черный чай',
        image: 'assets/coffe.png',
        price: 119),
    Product(
        category: 'Американо',
        name: 'Американо',
        image: 'assets/coffe.png',
        price: 149),
    Product(
        category: 'Американо',
        name: 'Американо',
        image: 'assets/coffe.png',
        price: 149),
    Product(
        category: 'Авторские напитки',
        name: 'Черный чай',
        image: 'assets/coffe.png',
        price: 119),
    Product(
        category: 'Авторские напитки',
        name: 'Черный чай',
        image: 'assets/coffe.png',
        price: 119),
  ];

  Map<String, List<Product>> categorizedProducts = {};

  @override
  void initState() {
    super.initState();
    categorizedProducts = _categorizeProducts(productList);
  }

  Map<String, List<Product>> _categorizeProducts(List<Product> products) {
    Map<String, List<Product>> categorized = {};
    for (var product in products) {
      if (!categorized.containsKey(product.category)) {
        categorized[product.category] = [];
      }
      categorized[product.category]?.add(product);
    }
    return categorized;
  }

  int get totalCartValue {
    int total = 0;
    cart.forEach((product, quantity) {
      total += product.price * quantity;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Column(
            children: [
              Category(
                onCategorySelected: _onCategorySelected,
                selectedIndex: selectedCategoryIndex,
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  controller: productScrollController,
                  itemCount: categorizedProducts.keys.length,
                  itemBuilder: (context, index) {
                    String category = categorizedProducts.keys.elementAt(index);
                    List<Product> productsInCategory =
                        categorizedProducts[category]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: productsInCategory.length,
                          itemBuilder: (context, index) {
                            final product = productsInCategory[index];
                            return ProductCard(
                              product: product,
                              onAddToCart: () {
                                setState(() {
                                  cart[product] = (cart[product] ?? 0) + 1;
                                });
                              },
                              onRemoveFromCart: () {
                                setState(() {
                                  if (cart[product] != null &&
                                      cart[product]! > 0) {
                                    cart[product] = cart[product]! - 1;
                                    if (cart[product] == 0) {
                                      cart.remove(product);
                                    }
                                  }
                                });
                              },
                              cartQuantity: cart[product] ?? 0,
                              onIncrease: () {
                                setState(() {
                                  if (cart[product]! < 10) {
                                    cart[product] = cart[product]! + 1;
                                  }
                                });
                              },
                              onDecrease: () {
                                setState(() {
                                  if (cart[product]! > 1) {
                                    cart[product] = cart[product]! - 1;
                                  } else {
                                    cart.remove(product);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          if (cart.isNotEmpty)
            Positioned(
              bottom: 30,
              right: 20,
              child: Container(
                height: 45,
                width: 70,
                child: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    _showCartBottomSheet(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(Icons.shopping_bag_outlined),
                      Text(
                        '${totalCartValue}₽',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ограничиваем высоту BottomSheet
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 30,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Иконка мусорки для очистки корзины
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Ваш заказ',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        cart.clear();
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const Divider(),
              // Список товаров в корзине
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: cart.entries.map((entry) {
                    final product = entry.key;
                    final quantity = entry.value;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: quantity,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 5, top: 5), // Отступ между товарами
                          child: ListTile(
                            leading: Image.asset(product.image, width: 50),
                            title: Text(product.name,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                            trailing: Text(
                              '${product.price}₽',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    _onOrderPlaced(context); // Вызываем обработчик при нажатии
                  },
                  child: Text(
                    'Оформить заказ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _onOrderPlaced(BuildContext context) {
    // Очищаем корзину
    setState(() {
      cart.clear();
    });

    // Закрываем BottomSheet
    Navigator.pop(context);

    // Отображаем SnackBar с сообщением об успешном оформлении заказа
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Заказ cоздан!', style: TextStyle(fontWeight: FontWeight.w400),),
        backgroundColor: Colors.grey,
      ),
    );
  }

  void _onCategorySelected(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });

    // Прокрутка списка продуктов до соответствующей категории
    _scrollToCategory(index);
  }

  void _scrollToCategory(int index) {
    double position = 0.0;
    // Рассчитываем позицию для прокрутки, чтобы категория была вверху
    for (int i = 0; i < index; i++) {
      position +=
          categorizedProducts[categorizedProducts.keys.elementAt(i)]!.length *
              100;
    }

    productScrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

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









