import 'package:riverpod/riverpod.dart';
import 'package:riverpos/_core/api_client.dart';
import 'package:riverpos/_core/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// I could create this as simple global variable... But since I had to understrand "shittedspot" (riverpod)
/// I had to do this way.
final dependenciesProvider = Provider<DependenciesContainer>((ref) {
  throw UnimplementedError('dependenciesProvider was not overridden');
});

/// better would be this way:
///
/// final dependencies = DependenciesContainer();
///
/// and fully initiating this varilable above in initialization.dart file

class DependenciesContainer {
  late final AppDatabase appDatabase;

  late final SharedPreferences sharedPreferences;

  late final IApiClient apiClient;
}
