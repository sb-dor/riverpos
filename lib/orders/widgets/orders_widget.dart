import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpos/auth/providers/auth_provider.dart';

/// {@template orders_widget}
/// OrdersWidget widget.
/// {@endtemplate}
class OrdersWidget extends ConsumerStatefulWidget {
  /// {@macro orders_widget}
  const OrdersWidget({
    super.key, // ignore: unused_element_parameter
  });

  @override
  ConsumerState<OrdersWidget> createState() => _OrdersWidgetState();
}

/// State for widget OrdersWidget.
class _OrdersWidgetState extends ConsumerState<OrdersWidget> {
  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    // Initial state initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) {
    final authProviderState = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Orders screen')),
      body: CustomScrollView(
        slivers: [SliverToBoxAdapter(child: Text("Signed in: ${authProviderState.user?.fullName ?? '-'}"))],
      ),
    );
  }
}
