import 'package:riverpod/riverpod.dart';
import 'package:riverpos/initialization/models/dependencies.dart';
import 'package:riverpos/sd_auth/data/server_database_repository.dart';
import 'package:riverpos/sd_auth/models/server_database.dart';

final sdAuthenticationRepositoryProvider =
    Provider<ISDAuthenticationRepository>((ref) {
      return SDAuthenticationRepositoryImpl(
        sharedPreferences: ref.watch(dependenciesProvider).sharedPreferences,
      );
    });

final serverDatabaseProvider =
    NotifierProvider<ServerDatabaseProvider, ServerDatabaseState>(
      ServerDatabaseProvider.new,
    );

sealed class ServerDatabaseState {
  const ServerDatabaseState();

  const factory ServerDatabaseState.initial() = ServerDatabase$InitialState;

  const factory ServerDatabaseState.inProgress() =
      ServerDatabase$InProgressState;

  const factory ServerDatabaseState.error({Object? error}) =
      ServerDatabase$ErrorState;

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

class ServerDatabaseProvider extends Notifier<ServerDatabaseState> {
  @override
  ServerDatabaseState build() => ServerDatabaseState.initial();

  void load() async {
    try {
      if (state is ServerDatabase$InProgressState) return;

      state = ServerDatabaseState.inProgress();

      /// бля
      final serverDatabaseRepository = ref.read(
        sdAuthenticationRepositoryProvider,
      );

      await Future.delayed(const Duration(seconds: 1));

      final serverDatabase = await serverDatabaseRepository
          .localServerDatabase();
      //
      state = ServerDatabaseState.completed(serverDatabase);
    } catch (error, stackTrace) {
      state = ServerDatabaseState.error(error: error);
      throw Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
