import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpos/_core/local_pagination_util.dart';
import 'package:riverpos/initialization/models/dependencies.dart';
import 'package:riverpos/orders/data/orders_repository.dart';
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

  static OrdersScopeState of(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<OrdersScopeInhWidget>()?.widget;
    assert(widget != null, 'No OrdersScopeInhWidget was found in element tree');
    return (widget as OrdersScopeInhWidget).state;
  }

  @override
  State<OrdersScope> createState() => OrdersScopeState();
}

/// State for widget OrdersScope.
class OrdersScopeState extends State<OrdersScope> {
  late final StateNotifierProvider<OrdersProvider, OrdersState> ordersProvider;

  @override
  void initState() {
    super.initState();

    ordersProvider = StateNotifierProvider(
      (_) => OrdersProvider(
        ordersRepository: OrdersRepositoryImpl(appDatabase: dependencies.appDatabase),
        localPaginationUtil: localPaginationUtilProvider,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [ordersProvider],
    child: OrdersScopeInhWidget(state: this, child: OrdersWidget()),
  );
}

/// {@template orders_scope}
/// OrdersScopeInhWidget widget.
/// {@endtemplate}
class OrdersScopeInhWidget extends InheritedWidget {
  /// {@macro orders_scope}
  const OrdersScopeInhWidget({
    required this.state,
    required super.child,
    super.key, // ignore: unused_element_parameter
  });

  final OrdersScopeState state;

  @override
  bool updateShouldNotify(covariant OrdersScopeInhWidget oldWidget) => false;
}
