import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpos/auth/providers/auth_provider.dart';

/// {@template cart_widget}
/// CartWidget widget.
/// {@endtemplate}
class CartWidget extends ConsumerStatefulWidget {
  /// {@macro cart_widget}
  const CartWidget({
    super.key, // ignore: unused_element_parameter
  });

  @override
  ConsumerState<CartWidget> createState() => _CartWidgetState();
}

/// State for widget CartWidget.
class _CartWidgetState extends ConsumerState<CartWidget> {
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
  Widget build(BuildContext context) {
    final authProviderState = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Cart Widget')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Text(
              "Signed in: ${authProviderState.user?.fullName ?? '-'}",
            ),
          ),
        ],
      ),
    );
  }
}
