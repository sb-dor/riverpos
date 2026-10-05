import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpos/orders/providers/orders_providers.dart';
import 'package:riverpos/orders/widgets/orders_widget.dart';

/// {@template orders_scope}
/// OrdersScope widget.
/// {@endtemplate}
class OrdersScope extends StatefulWidget {
  /// {@macro orders_scope}
  const OrdersScope({
    super.key, // ignore: unused_element_parameter
  });

  @override
  State<OrdersScope> createState() => _OrdersScopeState();
}

/// State for widget OrdersScope.
class _OrdersScopeState extends State<OrdersScope> {
  @override
  Widget build(BuildContext context) => ProviderScope(overrides: [ordersProvider], child: OrdersWidget());
}
