import 'package:drift/drift.dart';
import 'package:riverpos/_core/database/app_database.dart';
import 'package:riverpos/orders/models/order.dart';

abstract interface class ICartRepository {
  Future<bool> save(Order order);

  Future<bool> update(Order order);
}

final class Cart$LocalRepositoryImpl implements ICartRepository {
  Cart$LocalRepositoryImpl({required this._appDatabase});

  final AppDatabase _appDatabase;

  @override
  Future<bool> save(Order order) async {
    await update(order);

    final id = await _appDatabase
        .into(_appDatabase.tempOrdersTable)
        .insert(
          TempOrdersTableCompanion(
            uuid: Value(order.uid),
            invoice: Value(order.uid),
          ),
        );

    await _appDatabase.batch((batch) {
      for (final item in order.orderItems) {
        batch.insert(
          _appDatabase.tempOrderItemsTable,
          TempOrderItemsTableCompanion(
            orderId: Value(id),
            uid: Value(item.uid),
            productId: Value(item.product.id),
            productName: Value(item.product.name),
            price: Value(item.price),
            qty: Value(item.qty),
          ),
        );
      }
    });

    return true;
  }

  /// for local update its better delete all related order and order items and reset data
  @override
  Future<bool> update(Order order) async {
    final checkForUUID = await (_appDatabase.select(
      _appDatabase.tempOrdersTable,
    )..where((filter) => filter.uuid.equals(order.uid))).getSingleOrNull();

    if (checkForUUID == null) return false;

    await (_appDatabase.delete(
      _appDatabase.tempOrdersTable,
    )..where(((filter) => filter.id.equals(checkForUUID.id)))).go();

    await (_appDatabase.delete(
      _appDatabase.tempOrderItemsTable,
    )..where((filter) => filter.orderId.equals(checkForUUID.id))).go();

    return true;
  }
}
