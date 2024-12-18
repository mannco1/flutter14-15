import 'package:flutter/material.dart';
import 'package:pks/models/products.dart';

import '../components/api_service.dart';
import '../components/auth_service.dart';
import '../models/user_model.dart';

class ItemView extends StatefulWidget {
  final Product productItem;
  const ItemView({super.key, required this.productItem});

  @override
  createState() => ItemViewState();
}

class ItemViewState extends State<ItemView> {
  bool addedToCart = false;
  final ApiService _apiService = ApiService();
  late Future<User> user;
  late int userId;


  @override
  void initState() {
    super.initState();
    user = ApiService().getUserByEmail(AuthService().getCurrentUserEmail());
    user.then((currentUser) {
      userId = currentUser.id;
      _checkIfAddedToCart();
    });
  }
  Future<void> _checkIfAddedToCart() async {
    try {
      final cartItems = await _apiService.getCart(userId);
      setState(() {
        addedToCart = cartItems.any((item) => item['product_id'] == widget.productItem.id);
      });
    } catch (e) {
      debugPrint('Error checking if item is in cart: $e');
    }
  }


  Future<void> _addToCart() async {
    try {
      await _apiService.addToCart(widget.productItem.id, userId);
      setState(() {
        addedToCart = true;
      });
      debugPrint('Product added to cart');
    } catch (e) {
      debugPrint('Error adding product to cart: $e');
    }
  }

  Future<void> _removeFromCart() async {
    try {
      await _apiService.removeFromCart( widget.productItem.id, userId);
      setState(() {
        addedToCart = false;
      });
      debugPrint('Product removed from cart');
    } catch (e) {
      debugPrint('Error removing product from cart: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.productItem.Name)),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 16.6, right: 16.0, bottom: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(widget.productItem.img,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width / 2,
                          fit: BoxFit.fill)
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(widget.productItem.Description,
                    style: const TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 250,
                  )
                ],
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: addedToCart
                          ? const Color.fromARGB(255, 72, 209, 204)
                          : const Color.fromARGB(255,75, 0, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsets.all(10.0)),
                  child: Text(
                      addedToCart
                          ? "Добавлено в корзину - ${widget.productItem.Price} руб."
                          : "Добавить в корзину - ${widget.productItem.Price} руб.",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  onPressed: () {
                    if (addedToCart) {
                      _removeFromCart();
                    } else {
                      _addToCart();
                    }
                  },
                ),
              ))
        ]));
  }
}
