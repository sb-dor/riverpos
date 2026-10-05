import 'package:riverpos/_core/database/app_database.dart';
import 'package:riverpos/orders/models/order.dart';
import 'package:riverpos/orders/models/order_item.dart';
import 'package:riverpos/products/models/product.dart';
import 'package:uuid/uuid.dart';

abstract interface class IOrdersRepository {
  Future<List<Order>> orders({required int page, required int perPage});
}

class OrdersRepositoryImpl implements IOrdersRepository {
  OrdersRepositoryImpl({required this._appDatabase});

  final AppDatabase _appDatabase;

  @override
  Future<List<Order>> orders({required int page, required int perPage}) async {
    final offset = (page - 1) * perPage;

    final ordersQ = await (_appDatabase.select(_appDatabase.tempOrdersTable)..limit(perPage, offset: offset)).get();

    final List<Order> orders = [];

    for (final item in ordersQ) {
      final orderItemsQ = await (_appDatabase.select(
        _appDatabase.tempOrderItemsTable,
      )..where((filter) => filter.orderId.equals(item.id))).get();

      final orderItems = orderItemsQ
          .map(
            (el) => OrderItem(
              uid: const Uuid().v4(),
              product: Product(id: el.productId!, name: el.productName!, price: el.price ?? 0),
              price: el.price ?? 0,
              qty: el.qty ?? 0,
            ),
          )
          .toList();

      orders.add(Order(uid: item.uuid ?? Uuid().v4(), orderItems: orderItems));
    }

    return orders;
  }
}
