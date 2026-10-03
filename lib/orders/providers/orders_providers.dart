import 'package:riverpos/orders/models/order.dart';

sealed class OrdersState {
  const OrdersState();
}

class Orders$InitialState extends OrdersState {
  const Orders$InitialState();
}

class Orders$InProgressState extends OrdersState {
  const Orders$InProgressState();
}

class Orders$ErrorState extends OrdersState {
  const Orders$ErrorState();
}

class Orders$CompletedState extends OrdersState {
  const Orders$CompletedState({required this.orders, required this.page, required this.hasMore});

  final List<Order> orders;
  final int page;
  final bool hasMore;
}
