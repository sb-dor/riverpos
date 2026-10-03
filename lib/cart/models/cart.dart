import 'package:riverpos/orders/models/order.dart';
import 'package:riverpos/orders/models/order_item.dart';
import 'package:uuid/uuid.dart';

class Cart {
  Cart({Order? order}) : order = order ?? Order(uid: const Uuid().v4(), orderItems: <OrderItem>[]);

  final Order order;
}
