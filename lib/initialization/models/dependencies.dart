import 'package:riverpos/_core/api_client.dart';
import 'package:riverpos/_core/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dependencies = DependenciesContainer();

class DependenciesContainer {
  late final AppDatabase appDatabase;

  late final SharedPreferences sharedPreferences;

  late final IApiClient apiClient;
}
