import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dependenciesProvider = Provider<DependenciesContainer>((ref) {
  throw StateError('dependenciesProvider was not overridden');
});

class DependenciesContainer {
  late final SharedPreferences sharedPreferences;
}
