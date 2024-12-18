import 'package:pks/models/products.dart';

class Order {
  final int orderId;
  final int userId;
  final double total;
  final String status;
  final List<Product> products;

  Order({
    required this.orderId,
    required this.userId,
    required this.total,
    required this.status,
    required this.products,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List;
    List<Product> productsList =
    productList.map((i) => Product.fromJson(i)).toList();

    return Order(
      orderId: json['order_id'],
      userId: json['user_id'],
      total: (json['total'] as num).toDouble(),
      status: json['status'],
      products: productsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'total': total,
      'status': status,
      'products': products.map((pr) => pr.toJson()).toList(),
    };
  }
}