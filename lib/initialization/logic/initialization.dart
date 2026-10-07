import 'package:flutter/widgets.dart';
import 'package:riverpos/_core/api_client.dart';
import 'package:riverpos/_core/config.dart';
import 'package:riverpos/_core/database/app_database.dart';
import 'package:riverpos/initialization/models/dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitializationStepException implements Exception {
  InitializationStepException(this.error);

  final Object error;
}

Future<DependenciesContainer> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  final steps = await _initializeDependencies();
  for (final step in steps.entries) {
    try {
      await step.value(dependencies);
    } catch (error, stackTrace) {
      throw Error.throwWithStackTrace(InitializationStepException(error), stackTrace);
    }
  }
  return dependencies;
}

typedef InitializationStep = Map<String, Future<void> Function(DependenciesContainer dependencies)>;

Future<InitializationStep> _initializeDependencies() async {
  return {
    'appDatabaseInitialization': (dependencies) async =>
        dependencies.appDatabase = AppDatabase.defaults(name: Config.databaseName),
    'sharedPreferencesInitialization': (dependencies) async =>
        dependencies.sharedPreferences = await SharedPreferences.getInstance(),
    'apiClientInitialization': (dependencies) async => dependencies.apiClient = ApiClient(
      baseUrl: Config.apiAdminBaseUrl,
      apiClientHeaders: ApiClientHeaders(sharedPreferences: dependencies.sharedPreferences),
    ),
  };
}
