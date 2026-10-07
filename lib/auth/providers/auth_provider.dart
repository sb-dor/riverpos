import 'package:riverpod/legacy.dart';
import 'package:riverpos/auth/data/auth_repository.dart';
import 'package:riverpos/auth/models/identity.dart';
import 'package:riverpos/initialization/models/dependencies.dart';
import 'package:riverpos/sd_auth/providers/server_database_provider.dart';

final authProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) {
  final dependencies = ref.read(dependenciesProvider);
  final sdCompletedState = ref.read(serverDatabaseProvider) as ServerDatabase$CompletedState;
  return AuthProvider(
    authenticationRepository: AuthRepositoryImpl(
      sharedPreferences: dependencies.sharedPreferences,
      api: () => sdCompletedState.serverDatabase?.backendApi ?? '',
    ),
  );
});

sealed class AuthState {
  const AuthState();

  const factory AuthState.initial() = Auth$InitialState;

  const factory AuthState.inProgress() = Auth$InProgressState;

  const factory AuthState.error({Object? error}) = Auth$ErrorState;

  const factory AuthState.completed({required Identity identity}) = AuthenticatedState;

  User? get user => switch (this) {
    AuthenticatedState(:final identity) => identity as User,
    _ => null,
  };
}

class Auth$InitialState extends AuthState {
  const Auth$InitialState();
}

class Auth$InProgressState extends AuthState {
  const Auth$InProgressState();
}

class Auth$ErrorState extends AuthState {
  const Auth$ErrorState({this.error});

  final Object? error;
}

class AuthenticatedState extends AuthState {
  const AuthenticatedState({required this.identity});

  final Identity identity;
}

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider({required this._authenticationRepository, AuthState? state}) : super(state ?? AuthState.initial());

  final IAuthenticationRepository _authenticationRepository;

  void signIn({
    required String email,
    required String password,
    required void Function(String message) onMessage,
  }) async {
    try {
      if (state is Auth$InProgressState) return;

      final user = await _authenticationRepository.signIn(email: email, password: password, onMessage: onMessage);

      if (user == null) {
        state = AuthState.initial();
        return;
      }

      state = AuthState.completed(identity: user);
    } catch (error) {
      state = AuthState.error(error: error);
    }
  }
}
