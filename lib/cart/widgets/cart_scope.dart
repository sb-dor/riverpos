import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpos/cart/providers/cart_provider.dart';
import 'package:riverpos/cart/providers/save_cart_provider.dart';
import 'package:riverpos/cart/widgets/cart_widget.dart';
import 'package:riverpos/orders/models/order.dart';
import 'package:riverpos/products/providers/products_provider.dart';

/// {@template cart_scope}
/// CartScope widget.
/// {@endtemplate}
class CartScope extends ConsumerStatefulWidget {
  /// {@macro cart_scope}
  const CartScope({
    super.key, // ignore: unused_element_parameter
    required this.onSuccessfullySave,
    this.order,
  });

  static CartScopeState of(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<_CartScopeInhWidget>()
        ?.widget;
    assert(widget != null, 'No _CartScopeInhWidget was found in element tree');
    return (widget as _CartScopeInhWidget).state;
  }

  final void Function() onSuccessfullySave;
  final Order? order;

  @override
  ConsumerState<CartScope> createState() => CartScopeState();
}

/// State for widget CartScope.
class CartScopeState extends ConsumerState<CartScope> {
  late final order = widget.order;
  late final onSuccessfullyChange = widget.onSuccessfullySave;

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [productsProvider, cartProvider, saveCartProvider],
    child: _CartScopeInhWidget(state: this, child: CartWidget()),
  );
}

/// {@template cart_scope}
/// CartScopeInhWidget widget.
/// {@endtemplate}
class _CartScopeInhWidget extends InheritedWidget {
  /// {@macro cart_scope}
  const _CartScopeInhWidget({
    required this.state,
    required super.child,
    super.key, // ignore: unused_element_parameter
  });

  final CartScopeState state;

  @override
  bool updateShouldNotify(covariant _CartScopeInhWidget oldWidget) => false;
}
