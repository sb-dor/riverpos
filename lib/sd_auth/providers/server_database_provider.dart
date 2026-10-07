import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpos/initialization/models/dependencies.dart';
import 'package:riverpos/sd_auth/data/server_database_repository.dart';
import 'package:riverpos/sd_auth/models/server_database.dart';

final serverDatabaseProvider = StateNotifierProvider<ServerDatabaseProvider, ServerDatabaseState>(
  (_) => ServerDatabaseProvider(
    sdAuthenticationRepository: SDAuthenticationRepositoryImpl(
      sharedPreferences: dependencies.sharedPreferences,
    ),
  ),
);

sealed class ServerDatabaseState {
  const ServerDatabaseState();

  const factory ServerDatabaseState.initial() = ServerDatabase$InitialState;

  const factory ServerDatabaseState.inProgress() = ServerDatabase$InProgressState;

  const factory ServerDatabaseState.error({Object? error}) = ServerDatabase$ErrorState;

  const factory ServerDatabaseState.completed(ServerDatabase? serverDatabase) =
      ServerDatabase$CompletedState;
}

final class ServerDatabase$InitialState extends ServerDatabaseState {
  const ServerDatabase$InitialState();
}

final class ServerDatabase$InProgressState extends ServerDatabaseState {
  const ServerDatabase$InProgressState();
}

final class ServerDatabase$ErrorState extends ServerDatabaseState {
  const ServerDatabase$ErrorState({this.error});

  final Object? error;
}

final class ServerDatabase$CompletedState extends ServerDatabaseState {
  const ServerDatabase$CompletedState(this.serverDatabase);

  final ServerDatabase? serverDatabase;
}

class ServerDatabaseProvider extends StateNotifier<ServerDatabaseState> {
  ServerDatabaseProvider({required this._sdAuthenticationRepository, ServerDatabaseState? state})
    : super(state ?? ServerDatabaseState.initial());

  final ISDAuthenticationRepository _sdAuthenticationRepository;

  void load() async {
    try {
      if (state is ServerDatabase$InProgressState) return;

      state = ServerDatabaseState.inProgress();

      final serverDatabase = await _sdAuthenticationRepository.localServerDatabase();
      //
      state = ServerDatabaseState.completed(serverDatabase);
    } catch (error, stackTrace) {
      state = ServerDatabaseState.error(error: error);
      throw Error.throwWithStackTrace(error, stackTrace);
    }
  }

  void remoteServerDatabase({
    required String uid,
    required void Function(String message) onMessage,
  }) async {
    try {
      if (state is ServerDatabase$InProgressState) return;

      state = ServerDatabaseState.inProgress();

      final serverDatabase = await _sdAuthenticationRepository.serverDatabase(
        uid: uid,
        onMessage: onMessage,
      );
      //
      state = ServerDatabaseState.completed(serverDatabase);
    } catch (error) {
      state = ServerDatabaseState.error(error: error);
    }
  }

  void resetState() async => state = ServerDatabaseState.initial();
}
