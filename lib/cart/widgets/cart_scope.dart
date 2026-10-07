import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpos/_core/local_pagination_util.dart';
import 'package:riverpos/cart/data/cart_repository.dart';
import 'package:riverpos/cart/models/cart.dart';
import 'package:riverpos/cart/providers/cart_provider.dart';
import 'package:riverpos/cart/providers/save_cart_provider.dart';
import 'package:riverpos/cart/widgets/cart_widget.dart';
import 'package:riverpos/initialization/models/dependencies.dart';
import 'package:riverpos/orders/models/order.dart';
import 'package:riverpos/products/data/products_repository.dart';
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
    final widget = context.getElementForInheritedWidgetOfExactType<_CartScopeInhWidget>()?.widget;
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

  late final NotifierProvider<CartProvider, Cart> cartProvider;
  late final StateNotifierProvider<SaveCartProvider, SaveCartState> saveCartProvider;
  late final StateNotifierProvider<ProductsProvider, ProductsState> productsProvider;

  @override
  void initState() {
    super.initState();
    cartProvider = NotifierProvider(CartProvider.new);
    saveCartProvider = StateNotifierProvider(
      (_) => SaveCartProvider(cartRepository: Cart$LocalRepositoryImpl(appDatabase: dependencies.appDatabase)),
    );
    productsProvider = StateNotifierProvider(
      (ref) => ProductsProvider(
        productsRepository: ProductsRepositoryImpl(apiClient: dependencies.apiClient),
        localPaginationUtil: localPaginationUtilProvider,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [cartProvider, saveCartProvider, productsProvider],
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
