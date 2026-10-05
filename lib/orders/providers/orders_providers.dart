import 'package:riverpod/riverpod.dart';
import 'package:riverpos/_core/local_pagination_util.dart';
import 'package:riverpos/initialization/models/dependencies.dart';
import 'package:riverpos/orders/data/orders_repository.dart';
import 'package:riverpos/orders/models/order.dart';

/// I could create this globally with no riverpod's provider (simple global variable)
final ordersProvider = NotifierProvider<OrdersProvider, OrdersState>(OrdersProvider.new);

final ordersRepositoryImpl = Provider<IOrdersRepository>((ref) {
  final dependencies = ref.read(dependenciesProvider);
  return OrdersRepositoryImpl(appDatabase: dependencies.appDatabase);
});

sealed class OrdersState {
  const OrdersState();

  const factory OrdersState.initial() = Orders$InitialState;

  const factory OrdersState.inProgress() = Orders$InProgressState;

  const factory OrdersState.error({Object? error}) = Orders$ErrorState;

  const factory OrdersState.completed({required List<Order> orders, required int page, required bool hasMore}) =
      Orders$CompletedState;
}

class Orders$InitialState extends OrdersState {
  const Orders$InitialState();
}

class Orders$InProgressState extends OrdersState {
  const Orders$InProgressState();
}

class Orders$ErrorState extends OrdersState {
  const Orders$ErrorState({this.error});

  final Object? error;
}

class Orders$CompletedState extends OrdersState {
  const Orders$CompletedState({required this.orders, required this.page, required this.hasMore});

  final List<Order> orders;
  final int page;
  final bool hasMore;
}

class OrdersProvider extends Notifier<OrdersState> {
  @override
  OrdersState build() => OrdersState.initial();

  void load() async {
    try {
      if (state is Orders$InProgressState) return;

      state = OrdersState.inProgress();

      /// блять/бля/бла
      /// https://en.wikipedia.org/wiki/Coupling_(computer_programming)
      final ordersRepository = ref.read(ordersRepositoryImpl);
      final localPaginationUtil = ref.read(localPaginationUtilProvider);

      final orders = await ordersRepository.orders(page: 1, perPage: 20);

      final page = localPaginationUtil.checkIsListHasMorePageInt(list: orders, page: 1);

      final hasMore = localPaginationUtil.checkIsListHasMorePageBool(list: orders, limitInPage: 20);

      state = OrdersState.completed(orders: orders, page: page, hasMore: hasMore);
    } catch (error) {
      state = OrdersState.error(error: error);
    }
  }

  void paginate() async {
    try {
      if (state is! Orders$CompletedState) return;
      final completedState = state as Orders$CompletedState;

      /// блять/бля/бла
      /// https://en.wikipedia.org/wiki/Coupling_(computer_programming)
      final ordersRepository = ref.read(ordersRepositoryImpl);
      final localPaginationUtil = ref.read(localPaginationUtilProvider);

      final orders = await ordersRepository.orders(page: completedState.page, perPage: 20);

      final page = localPaginationUtil.checkIsListHasMorePageInt(list: orders, page: completedState.page);

      final hasMore = localPaginationUtil.checkIsListHasMorePageBool(list: orders, limitInPage: 20);

      state = OrdersState.completed(orders: orders, page: page, hasMore: hasMore);
    } catch (error) {
      state = OrdersState.error(error: error);
    }
  }
}
