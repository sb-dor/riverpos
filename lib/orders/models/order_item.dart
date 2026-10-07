import 'package:riverpos/products/models/product.dart';

class OrderItem {
  OrderItem({
    required this.uid,
    required this.product,
    required this.price,
    required this.qty,
  });

  final String uid;
  final Product product;
  final double price;
  final double qty;

  double get total => price * qty;
}
