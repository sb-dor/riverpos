import 'package:drift/drift.dart';

/// [Identity] is not necessary here
/// Cause, when he enters to the app local saved [Order] will be loaded with
/// system's [Identity] automatically. When he logs out - all local saved data will be cleared
///
/// for local data it's not necessary to save all data
/// it's just a simple local data for loading last saved data
class TempOrdersTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get uuid => text().nullable()();

  TextColumn get invoice => text().nullable()();
}
