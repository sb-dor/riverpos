import 'package:drift/drift.dart';

/// for local data we save only few parameters
/// productId and qty
class TempOrderItemsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get uid => text().nullable()();

  IntColumn get orderId => integer().nullable()();

  IntColumn get productId => integer().nullable()();

  TextColumn get productName => text().nullable()();

  RealColumn get price => real().nullable()();

  RealColumn get qty => real().nullable()();
}
