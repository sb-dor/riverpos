import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpos/cart/providers/cart_provider.dart';

/// {@template cart_items_widget}
/// CartItemsWidget widget.
/// {@endtemplate}
class CartItemsWidget extends ConsumerStatefulWidget {
  /// {@macro cart_items_widget}
  const CartItemsWidget({
    super.key, // ignore: unused_element_parameter
  });

  @override
  ConsumerState<CartItemsWidget> createState() => _CartItemsWidgetState();
}

/// State for widget CartItemsWidget.
class _CartItemsWidgetState extends ConsumerState<CartItemsWidget> {
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
    final cartProviderState = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Cart items')),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList.builder(
              itemCount: cartProviderState.order.orderItems.length,
              itemBuilder: (context, index) {
                final item = cartProviderState.order.orderItems[index];
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
                            Text(item.product.name, style: TextStyle(fontWeight: .bold)),
                            Text(item.price.toString()),
                          ],
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.remove), color: Colors.red),

                      Text(item.qty.toString(), style: TextStyle(fontWeight: .bold)),

                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add, color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
