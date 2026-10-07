import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpos/auth/providers/auth_provider.dart';
import 'package:riverpos/cart/providers/save_cart_provider.dart';
import 'package:riverpos/cart/widgets/cart_items_widget.dart';
import 'package:riverpos/cart/widgets/cart_scope.dart';
import 'package:riverpos/products/providers/products_provider.dart';

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
  late final _scope = CartScope.of(context);
  late final _cartProvider = _scope.cartProvider;
  late final _saveCartProvider = _scope.saveCartProvider;
  late final _productsProvider = _scope.productsProvider;
  late final _onSuccessfullySave = _scope.onSuccessfullyChange;

  final ScrollController _scrollController = ScrollController();

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    // Initial state initialization

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_cartProvider.notifier).loadOrder(_scope.order);
      ref.read(_productsProvider.notifier).load();

      _scrollController.addListener(_scrollListener);
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    // Permanent removal of a tree stent
    super.dispose();
  }
  /* #endregion */

  void _scrollListener() {
    if (_scrollController.offset == _scrollController.position.maxScrollExtent) {
      ref.read(_productsProvider.notifier).paginate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProviderState = ref.watch(authProvider);
    final productsProviderState = ref.watch(_productsProvider);
    final cartProviderState = ref.watch(_cartProvider);

    ref.listen(_saveCartProvider, (prev, current) {
      if (current is SaveCart$CompletedState) {
        _onSuccessfullySave.call();
        Navigator.pop(context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Widget'),
        actions: [
          Badge(
            label: Text('${cartProviderState.order.orderItems.length}'),
            isLabelVisible: cartProviderState.order.orderItems.isNotEmpty,
            offset: Offset(-10, 1),
            child: IconButton(
              onPressed: () {
                // for getting current scope
                final scopeContainer = ProviderScope.containerOf(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UncontrolledProviderScope(
                      container: scopeContainer,
                      child: CartItemsWidget(cartProvider: _cartProvider),
                    ),
                  ),
                );
              },
              icon: Icon(CupertinoIcons.cart),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: Text("Signed in: ${authProviderState.user?.fullName ?? '-'}")),
                  switch (productsProviderState) {
                    Products$InitialState() => SliverToBoxAdapter(child: SizedBox.shrink()),
                    Products$InProgressState() => SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator.adaptive()),
                    ),
                    Products$ErrorState(:final error) => SliverFillRemaining(
                      child: Center(child: Text(error.toString())),
                    ),
                    Products$CompletedState(:final products) => SliverList.separated(
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              CircleAvatar(radius: 25, child: ColoredBox(color: Colors.green)),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: .start,
                                  crossAxisAlignment: .start,
                                  children: [
                                    Text(product.name, style: TextStyle(fontWeight: .bold)),
                                    Text(product.price.toString()),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  ref.read(_cartProvider.notifier).addProduct(product);
                                },
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  },
                  if (productsProviderState is Products$CompletedState && productsProviderState.hasMore)
                    SliverToBoxAdapter(child: CircularProgressIndicator.adaptive()),
                ],
              ),
            ),
            if (cartProviderState.order.orderItems.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: .all(Colors.green)),
                    onPressed: () {
                      ref.read(_saveCartProvider.notifier).save(cartProviderState.order);
                    },
                    child: Text('save'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
