import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:l/l.dart';
import 'package:riverpos/sd_auth/models/server_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'json_util.dart';

abstract interface class IApiClient {
  Future<Map<String, Object?>> get(
    String url, {
    Map<String, String>? queryParameters,
  });

  Future<Map<String, Object?>> post(String url, {Map<String, Object?>? body});
}

abstract interface class IApiClientHeaders {
  Future<Map<String, String>> headers();
}

class ApiClientHeaders implements IApiClientHeaders {
  ApiClientHeaders({required this._sharedPreferences});

  final SharedPreferences _sharedPreferences;

  @override
  Future<Map<String, String>> headers() async {
    final headers = <String, String>{};
    final token = _sharedPreferences.getString('token');
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final localSD = _sharedPreferences.getString('local_sd');
    if (localSD != null) {
      final serverDatabase = ServerDatabase.fromJson(
        JsonUtil.jsonDecode(localSD)!,
      );
      headers['X-Store-Db'] = serverDatabase.databaseName;
    }

    final warehouseId = _sharedPreferences.getInt('warehouse_id');
    if (warehouseId != null) {
      headers['X-Warehouse-Id'] = warehouseId.toString();
    }

    l
      ..d('Local server database: $localSD')
      ..d('Request sending headers: $headers');

    return headers;
  }
}

class ApiClient implements IApiClient {
  ApiClient({
    required this.baseUrl,
    http.Client? client,
    required this._apiClientHeaders,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;
  final IApiClientHeaders _apiClientHeaders;

  @override
  Future<Map<String, Object?>> get(
    String url, {
    Map<String, String>? queryParameters,
  }) async {
    String completedUrl = url;
    final completedQueryParams = _getQueryParams(queryParameters);
    if (completedQueryParams != null) completedUrl += completedQueryParams;
    final headers = await _apiClientHeaders.headers();
    final response = await _client.get(
      Uri.parse(completedUrl),
      headers: headers,
    );

    final converted = jsonDecode(response.body) as Map<String, Object?>;

    return converted;
  }

  @override
  Future<Map<String, Object?>> post(
    String url, {
    Map<String, Object?>? body,
    Map<String, String>? queryParameters,
  }) async {
    String completedUrl = url;
    final completedQueryParams = _getQueryParams(queryParameters);
    if (completedQueryParams != null) completedUrl += completedQueryParams;
    final headers = await _apiClientHeaders.headers();
    final response = await _client.post(
      Uri.parse(completedUrl),
      body: body,
      headers: headers,
    );

    final converted = jsonDecode(response.body) as Map<String, Object?>;

    return converted;
  }

  String? _getQueryParams(Map<String, String>? queryParams) {
    if (queryParams == null) return null;
    final StringBuffer stringBuffer = StringBuffer();
    for (int i = 0; i < queryParams.entries.length; i++) {
      final key = queryParams.entries.elementAt(i).key;
      final value = queryParams.entries.elementAt(i).value;
      final result = '$key=$value';
      stringBuffer.write(i == 0 ? '?$result' : '&$result');
    }
    return stringBuffer.toString();
  }
}
