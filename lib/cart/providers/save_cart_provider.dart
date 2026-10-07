import 'package:riverpod/legacy.dart';
import 'package:riverpos/cart/data/cart_repository.dart';
import 'package:riverpos/initialization/models/dependencies.dart';
import 'package:riverpos/orders/models/order.dart';

final saveCartProvider = StateNotifierProvider<SaveCartProvider, SaveCartState>((ref) {
  final dependencies = ref.read(dependenciesProvider);
  return SaveCartProvider(cartRepository: Cart$LocalRepositoryImpl(appDatabase: dependencies.appDatabase));
});

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

class SaveCartProvider extends StateNotifier<SaveCartState> {
  SaveCartProvider({required this._cartRepository, SaveCartState? state}) : super(state ?? SaveCartState.initial());

  final ICartRepository _cartRepository;

  void save(Order order) async {
    try {
      if (state is SaveCart$InProgressState) return;

      state = SaveCartState.inProgress();

      final save = await _cartRepository.save(order);

      if (save) {
        state = SaveCartState.completed();
      } else {
        state = SaveCartState.initial();
      }
    } catch (error) {
      state = SaveCartState.error(error: error);
    }
  }
}
