import 'package:riverpos/orders/models/order_item.dart';

class Order {
  Order({required this.uid, required this.orderItems});

  @override
  int get hashCode => uid.hashCode ^ orderItems.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order &&
          uid == other.uid &&
          orderItems.hashCode == other.orderItems.hashCode;

  final String uid;
  final List<OrderItem> orderItems;

  double get total => orderItems.fold(0.0, (prev, item) => prev + item.total);

  Order copyWith({String? uid, List<OrderItem>? orderItems}) =>
      Order(uid: uid ?? this.uid, orderItems: orderItems ?? this.orderItems);
}
