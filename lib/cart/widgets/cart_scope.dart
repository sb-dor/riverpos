import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpos/cart/widgets/cart_widget.dart';

/// {@template cart_scope}
/// CartScope widget.
/// {@endtemplate}
class CartScope extends ConsumerStatefulWidget {
  /// {@macro cart_scope}
  const CartScope({
    super.key, // ignore: unused_element_parameter
  });

  @override
  ConsumerState<CartScope> createState() => _CartScopeState();
}

/// State for widget CartScope.
class _CartScopeState extends ConsumerState<CartScope> {
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
  Widget build(BuildContext context) => ProviderScope(child: CartWidget());
}
