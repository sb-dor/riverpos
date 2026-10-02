import 'dart:convert';

import 'package:flutter/foundation.dart';
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

bool isSuccessStatusCode(int statusCode) =>
    statusCode >= 200 && statusCode < 300;

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

// --- Errors --- //

@immutable
sealed class APIClientException implements Exception {
  const APIClientException({
    this.serverCode,
    this.serverError,
    this.serverMessage,
  });

  /// HTTP status code.
  /// If the request was not sent, this will be 0.
  abstract final int statusCode;

  /// Client-side error code — a value this client invented (`network_error`,
  /// `decoding_error`, …). **Not** the server's `code`; see [serverCode].
  abstract final String code;

  /// Client-side, English, developer-facing. Never show this to a user.
  abstract final String message;

  /// The source error object.
  abstract final Object? error;

  /// Additional datasources.
  abstract final Object? data;

  /// The server's stable `code` from the response envelope, when present.
  ///
  /// This is the value to branch on — never string-match the localized text.
  /// `omitempty` server-side, so `null` simply means the endpoint did not set one.
  final String? serverCode;

  /// The server's `error` field — localized (Russian), already sanitised.
  final String? serverError;

  /// The server's `message` field — localized (Russian). On `PATCH`/`DELETE`
  /// paths this is often just an operation label («Не удалось удалить»).
  final String? serverMessage;

  /// The text to show a user, or `null` when the server said nothing useful.
  ///
  /// Prefers [serverError] over [serverMessage] because `message` is frequently
  /// a generic operation label while `error` carries the specific reason — except
  /// on the revision 409s, where the specific text is in `message` and there is no
  /// `error`, which this ordering also handles.
  String? get displayMessage {
    final e = serverError?.trim();
    if (e != null && e.isNotEmpty) return e;
    final m = serverMessage?.trim();
    if (m != null && m.isNotEmpty) return m;
    return null;
  }

  @override
  String toString() => displayMessage ?? message;
}

/// Rate limit (`429`).
///
/// Previously folded into [APIClientException$400], which made it indistinguishable
/// from a validation failure — so a throttled login rendered as "wrong password".
final class APIClientException$RateLimit extends APIClientException {
  const APIClientException$RateLimit({
    required this.code,
    required this.message,
    required this.statusCode,
    this.retryAfter,
    this.error,
    this.data,
    super.serverCode,
    super.serverError,
    super.serverMessage,
  });

  /// Value of the `Retry-After` header, when the server sent a parseable one.
  ///
  /// The login/OTP buckets send `5` — the only rate-limited endpoints this app calls.
  /// Back off for this long — never auto-retry in a tight loop.
  final Duration? retryAfter;

  @override
  final String code;

  @override
  final String message;

  @override
  final int statusCode;

  @override
  final Object? error;

  @override
  final Object? data;
}

/// Authorization exception.
final class APIClientException$Authorization extends APIClientException {
  const APIClientException$Authorization({
    required this.code,
    required this.message,
    required this.statusCode,
    this.error,
    this.data,
    super.serverCode,
    super.serverError,
    super.serverMessage,
  });

  @override
  final String code;

  @override
  final String message;

  @override
  final int statusCode;

  @override
  final Object? error;

  @override
  final Object? data;
}

/// Network exception.
final class APIClientException$Network extends APIClientException {
  const APIClientException$Network({
    required this.code,
    required this.message,
    required this.statusCode,
    this.error,
    this.data,
    super.serverCode,
    super.serverError,
    super.serverMessage,
  });

  @override
  final String code;

  @override
  final String message;

  @override
  final int statusCode;

  @override
  final Object? error;

  @override
  final Object? data;
}

/// Client exception.
final class APIClientException$Client extends APIClientException {
  const APIClientException$Client({
    required this.code,
    required this.message,
    required this.statusCode,
    this.error,
    this.data,
    super.serverCode,
    super.serverError,
    super.serverMessage,
  });

  @override
  final String code;

  @override
  final String message;

  @override
  final int statusCode;

  @override
  final Object? error;

  @override
  final Object? data;
}

final class APIClientException$400 extends APIClientException {
  const APIClientException$400({
    required this.code,
    required this.message,
    required this.statusCode,
    this.error,
    this.data,
    super.serverCode,
    super.serverError,
    super.serverMessage,
  });

  @override
  final String code;

  @override
  final String message;

  @override
  final int statusCode;

  @override
  final Object? error;

  @override
  final Object? data;
}
