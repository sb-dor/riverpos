import 'package:riverpod/riverpod.dart';
import 'package:riverpos/cart/data/cart_repository.dart';
import 'package:riverpos/initialization/models/dependencies.dart';
import 'package:riverpos/orders/models/order.dart';

/// I could create this globally with no riverpod's provider (simple global variable)
final cartRepositoryImpl = Provider<ICartRepository>((ref) {
  final dependencies = ref.read(dependenciesProvider);
  return Cart$LocalRepositoryImpl(appDatabase: dependencies.appDatabase);
});

final saveCartProvider = NotifierProvider(SaveCartProvider.new);

sealed class SaveCartState {
  const SaveCartState();

  const factory SaveCartState.initial() = SaveCart$InitialState;

  const factory SaveCartState.inProgress() = SaveCart$InProgressState;

  const factory SaveCartState.error({Object? error}) = SaveCart$ErrorState;

  const factory SaveCartState.completed() = SaveCart$CompletedState;
}

class SaveCart$InitialState extends SaveCartState {
  const SaveCart$InitialState();
}

class SaveCart$InProgressState extends SaveCartState {
  const SaveCart$InProgressState();
}

class SaveCart$ErrorState extends SaveCartState {
  const SaveCart$ErrorState({this.error});

  final Object? error;
}

class SaveCart$CompletedState extends SaveCartState {
  const SaveCart$CompletedState();
}

class SaveCartProvider extends Notifier<SaveCartState> {
  @override
  SaveCartState build() => SaveCartState.initial();

  void save(Order order) async {
    try {
      if (state is SaveCart$InProgressState) return;

      /// блять/бля/бла
      /// https://en.wikipedia.org/wiki/Coupling_(computer_programming)
      final cartRepository = ref.read(cartRepositoryImpl);

      state = SaveCartState.inProgress();

      await cartRepository.save(order);

      state = SaveCartState.completed();
    } catch (error) {
      state = SaveCartState.error(error: error);
    }
  }
}
