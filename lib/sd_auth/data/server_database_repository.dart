import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:l/l.dart';
import 'package:riverpos/_core/config.dart';
import 'package:riverpos/_core/json_util.dart';
import 'package:riverpos/sd_auth/models/server_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class ISDAuthenticationRepository {
  Future<ServerDatabase?> localServerDatabase();

  Future<ServerDatabase?> serverDatabase({
    required String uid,
    required void Function(String message) onMessage,
    String? baseUrl,
  });

  Future<void> setLocalServerDatabase(ServerDatabase serverDatabase);

  Future<bool> clearLocalServerDatabase();
}

final class SDAuthenticationRepositoryImpl
    implements ISDAuthenticationRepository {
  SDAuthenticationRepositoryImpl({
    http.Client? apiClient,
    required this._sharedPreferences,
  }) : _apiClient = apiClient ?? http.Client();

  final http.Client _apiClient;
  final SharedPreferences _sharedPreferences;

  final String _serverDatabase = '/get/server/database/by/uid';

  @override
  Future<ServerDatabase?> localServerDatabase() async {
    final localServerDatabase = _sharedPreferences.getString('local_sd');

    if (localServerDatabase == null) return null;

    final json = JsonUtil.jsonDecode(localServerDatabase);

    if (json == null) return null;

    return ServerDatabase.fromJson(json);
  }

  @override
  Future<ServerDatabase?> serverDatabase({
    required String uid,
    required void Function(String message) onMessage,
    String? baseUrl,
  }) async {
    final normalizedBaseUrl = (baseUrl ?? Config.apiAdminBaseUrl).replaceFirst(
      RegExp(r'/+$'),
      '',
    );
    final response = await _apiClient.get(
      Uri.parse('$normalizedBaseUrl$_serverDatabase')
          .replace(queryParameters: {'uid': uid}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Not compatible status code for getting server database: ${response.body}',
      );
    }

    final json = JsonUtil.jsonDecode(response.body);

    if (json != null && json.containsKey('success')) {
      l.d(json);

      if (json.containsKey('message')) {
        onMessage("${json['message']}");
      }

      if (json['success'] == true) {
        var serverDatabase = ServerDatabase.fromJson(
          json['server_database'] as Map<String, Object?>,
        );
        serverDatabase = serverDatabase.copyWith(
          backendApi: '${serverDatabase.backendApi}/api',
          uid: () => serverDatabase.uid ?? uid,
        );
        await _sharedPreferences.setString(
          'local_sd',
          jsonEncode(serverDatabase.toMap()),
        );
        return serverDatabase;
      }

      return null;
    }

    throw Exception('Server database not found: ${response.body}');
  }

  @override
  Future<void> setLocalServerDatabase(ServerDatabase serverDatabase) async {
    await _sharedPreferences.setString(
      'local_sd',
      jsonEncode(serverDatabase.toMap()),
    );
  }

  @override
  Future<bool> clearLocalServerDatabase() async {
    return await _sharedPreferences.remove('local_sd');
  }
}
