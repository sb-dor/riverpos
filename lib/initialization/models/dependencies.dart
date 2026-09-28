import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dependenciesProvider = Provider<DependenciesContainer>((ref) {
  return DependenciesContainer();
});

class DependenciesContainer {
  late final SharedPreferences sharedPreferences;
}
