import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpos/_core/database/tables/temp_order_items_table.dart';
import 'package:riverpos/_core/database/tables/temp_orders_table.dart';

part 'app_database.g.dart';

/// {@template database}
/// The drift-managed database configuration
/// {@endtemplate}
@DriftDatabase(tables: [TempOrdersTable, TempOrderItemsTable])
class AppDatabase extends _$AppDatabase {
  /// {@macro database}
  AppDatabase(super.e);

  /// {@macro database}
  AppDatabase.defaults({required String name})
    : super(
        driftDatabase(
          name: name,
          native: const DriftNativeOptions(shareAcrossIsolates: true),
          // Update the sqlite3Wasm and driftWorker paths to match the location of the files in your project if needed.
          // https://drift.simonbinder.eu/web/#prerequisites
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 1;

  // For more info about migrations see https://drift.simonbinder.eu/Migrations/step_by_step/
  //
  // Every step must use the versioned `schema` accessors (from database.steps.dart),
  // never the database's current table getters: current getters always reflect the
  // NEWEST schema, so old steps silently change meaning as tables evolve — that once
  // made `from8To9` create a table that already contained the columns `from9To10`
  // tries to add, crashing every upgrade from schema 8 or older.
  // Each step reproduces exactly the schema recorded in drift_schemas/app_database.
  // @override
  // MigrationStrategy get migration {
  //   return MigrationStrategy();
  // }
}
