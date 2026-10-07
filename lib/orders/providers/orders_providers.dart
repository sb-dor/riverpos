import 'package:riverpod/legacy.dart';
import 'package:riverpos/_core/local_pagination_util.dart';
import 'package:riverpos/orders/data/orders_repository.dart';
import 'package:riverpos/orders/models/order.dart';

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

class OrdersProvider extends StateNotifier<OrdersState> {
  OrdersProvider({required this._ordersRepository, required this._localPaginationUtil, OrdersState? state})
    : super(state ?? OrdersState.initial());

  final IOrdersRepository _ordersRepository;
  final LocalPaginationUtil _localPaginationUtil;

  void load() async {
    try {
      if (state is Orders$InProgressState) return;

      state = OrdersState.inProgress();

      final orders = await _ordersRepository.orders(page: 1, perPage: 20);

      final page = _localPaginationUtil.checkIsListHasMorePageInt(list: orders, page: 1);

      final hasMore = _localPaginationUtil.checkIsListHasMorePageBool(list: orders, limitInPage: 20);

      state = OrdersState.completed(orders: orders, page: page, hasMore: hasMore);
    } catch (error) {
      state = OrdersState.error(error: error);
    }
  }

  void paginate() async {
    try {
      if (state is! Orders$CompletedState) return;
      final completedState = state as Orders$CompletedState;
      if (!completedState.hasMore) return;

      final orders = await _ordersRepository.orders(page: completedState.page, perPage: 20);

      final page = _localPaginationUtil.checkIsListHasMorePageInt(list: orders, page: completedState.page);

      final hasMore = _localPaginationUtil.checkIsListHasMorePageBool(list: orders, limitInPage: 20);

      final currentOrders = List.of(completedState.orders)..addAll(orders);

      state = OrdersState.completed(orders: currentOrders, page: page, hasMore: hasMore);
    } catch (error) {
      state = OrdersState.error(error: error);
    }
  }
}
