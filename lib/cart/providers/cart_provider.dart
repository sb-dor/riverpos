import 'package:riverpod/riverpod.dart';
import 'package:riverpos/cart/models/cart.dart';
import 'package:riverpos/orders/models/order.dart';
import 'package:riverpos/orders/models/order_item.dart';
import 'package:riverpos/products/models/product.dart';
import 'package:uuid/uuid.dart';

class CartProvider extends Notifier<Cart> {
  @override
  Cart build() => Cart();

  void loadOrder(Order? order) => state = Cart(order: order);

  void addProduct(Product product) {
    /// just for testing
    final orderItems = List.of(state.order.orderItems);
    orderItems.add(OrderItem(uid: Uuid().v4(), product: product, price: product.price, qty: 1));
    state = state.copyWith(order: state.order.copyWith(orderItems: orderItems));
  }
}
