import 'package:flutter/widgets.dart';
import 'package:riverpos/initialization/models/dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitializationStepException implements Exception {
  InitializationStepException(this.error);

  final Object error;
}

Future<DependenciesContainer> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = DependenciesContainer();
  final steps = await _initializeDependencies();
  for (final step in steps.entries) {
    try {
      await step.value(dependencies);
    } catch (error, stackTrace) {
      throw Error.throwWithStackTrace(
        InitializationStepException(error),
        stackTrace,
      );
    }
  }
  return dependencies;
}

typedef InitializationStep =
    Map<String, Future<void> Function(DependenciesContainer dependencies)>;

Future<InitializationStep> _initializeDependencies() async {
  return {
    'sharedPreferencesInitialization': (dependencies) async =>
        dependencies.sharedPreferences = await SharedPreferences.getInstance(),
  };
}
