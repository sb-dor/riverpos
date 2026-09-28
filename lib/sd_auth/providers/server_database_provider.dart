import 'package:flutter/foundation.dart';
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

class ServerDatabaseState {
  ServerDatabaseState({this.inInProgress = false, this.serverDatabase});

  bool inInProgress;
  ServerDatabase? serverDatabase;

  @override
  int get hashCode => inInProgress.hashCode ^ serverDatabase.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerDatabaseState &&
          inInProgress == other.inInProgress &&
          serverDatabase == other.serverDatabase;

  ServerDatabaseState copyWith({
    bool? inInProgress,
    ValueGetter<ServerDatabase?>? serverDatabase,
  }) {
    return ServerDatabaseState(
      inInProgress: inInProgress ?? this.inInProgress,
      serverDatabase: serverDatabase != null
          ? serverDatabase()
          : this.serverDatabase,
    );
  }
}

class ServerDatabaseProvider extends Notifier<ServerDatabaseState> {
  @override
  ServerDatabaseState build() => ServerDatabaseState();

  void load() async {
    final serverDatabaseRepository = ref.read(
      sdAuthenticationRepositoryProvider,
    );

    try {
      if (state.inInProgress) return;
      state = state.copyWith(inInProgress: true);
      await Future.delayed(const Duration(seconds: 1));
      // final serverDatabase = await serverDatabaseRepository
      //     .localServerDatabase();
      state = state.copyWith(
        inInProgress: false,
      );
    } finally {
      state = state.copyWith(inInProgress: false);
    }
  }
}
