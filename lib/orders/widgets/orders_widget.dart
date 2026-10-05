import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpos/auth/providers/auth_provider.dart';
import 'package:riverpos/cart/widgets/cart_scope.dart';
import 'package:riverpos/orders/providers/orders_providers.dart';

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
  final ScrollController _scrollController = ScrollController();

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // Initial state initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    super.dispose();
  }
  /* #endregion */

  void _scrollListener() {
    if (_scrollController.offset == _scrollController.position.maxScrollExtent) {
      ref.read(ordersProvider.notifier).paginate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProviderState = ref.watch(authProvider);
    final ordersProviderState = ref.watch(ordersProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Orders screen')),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          ref.read(ordersProvider.notifier).load();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(child: Text("Signed in: ${authProviderState.user?.fullName ?? '-'}")),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScope(
                          onSuccessfullySave: () {
                            ref.read(ordersProvider.notifier).load();
                          },
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: ColoredBox(
                      color: Colors.green,
                      child: Center(
                        child: Text(
                          "Add order",
                          style: TextStyle(color: Colors.white, fontWeight: .w700),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            switch (ordersProviderState) {
              Orders$InitialState() => SliverToBoxAdapter(child: SizedBox.shrink()),
              Orders$InProgressState() => SliverFillRemaining(
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
              Orders$ErrorState(:final error) => SliverFillRemaining(child: Text(error.toString())),
              Orders$CompletedState(:final orders) => SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisExtent: 100, crossAxisCount: 3),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScope(
                            order: order,
                            onSuccessfullySave: () {
                              ref.read(ordersProvider.notifier).load();
                            },
                          ),
                        ),
                      );
                    },
                    child: Card(child: Center(child: Text('Order: ${index + 1}'))),
                  );
                },
              ),
            },

            if (ordersProviderState is Orders$CompletedState && ordersProviderState.hasMore)
              SliverToBoxAdapter(child: Center(child: CircularProgressIndicator.adaptive())),
          ],
        ),
      ),
    );
  }
}
