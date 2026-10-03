import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    // Initial state initialization
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [
      //
    ],
    child: OrdersWidget(),
  );
}
