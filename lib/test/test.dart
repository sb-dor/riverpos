import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final counterProvider = StateNotifierProvider<CounterProvider, int>((ref) => CounterProvider());

final counterAlertProvider = Provider<String>((ref) {
  // пздц
  final counterProviderState = ref.watch(counterProvider);
  return 'Value is: $counterProviderState';
});

class CounterProvider extends StateNotifier<int> {
  CounterProvider({int? state}) : super(state ?? 0);

  void increment() {
    state = state + 1;
  }
}
