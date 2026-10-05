import 'package:drift/drift.dart';
import 'package:riverpos/_core/database/app_database.dart';
import 'package:riverpos/orders/models/order.dart';

abstract interface class ICartRepository {
  Future<bool> save(Order order);
}

final class Cart$LocalRepositoryImpl implements ICartRepository {
  Cart$LocalRepositoryImpl({required this._appDatabase});

  final AppDatabase _appDatabase;

  @override
  Future<bool> save(Order order) async {
    final id = await _appDatabase
        .into(_appDatabase.tempOrdersTable)
        .insert(TempOrdersTableCompanion(uuid: Value(order.uid), invoice: Value(order.uid)));

    await _appDatabase.batch((batch) {
      for (final each in order.orderItems) {
        batch.insert(
          _appDatabase.tempOrderItemsTable,
          TempOrderItemsTableCompanion(
            orderId: Value(id),
            productId: Value(each.product.id),
            productName: Value(each.product.name),
            price: Value(each.price),
            qty: Value(each.qty),
          ),
        );
      }
    });

    return true;
  }
}
