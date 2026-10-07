import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpos/_core/api_client.dart';

/// Decodes an auth response into the same exception vocabulary the rest of the app
/// already speaks.
///
/// ## Why these calls do not go through `ApiClient`
///
/// `ApiClient` sends `Content-Type: application/json`. The auth endpoints are called
/// with `http.post(body: Map)`, which sends **form-urlencoded** — and that is what
/// the server has always received. Routing them through `ApiClient` would silently
/// change the request encoding on the login path, which is not a change to make on
/// an assumption. So the transport stays as it is and only the *decoding* is fixed.
///
/// ## What was wrong with decoding it inline
///
/// Every one of these call sites did `jsonDecode(response.body) as Map`, with no
/// guard, and then looked for the key it wanted:
///
/// * a **429** returns `{"error": "too many requests, slow down"}` — no `status`, no
///   `user` — so the lookup fell through to
///   `throw Exception("Couldn't get user due to a server error: …")`, and that string
///   was rendered to the user in place of "you are trying too often";
/// * a **502 HTML error page** or an empty body threw a raw `FormatException` out of
///   `jsonDecode`, killing the sign-in with no message at all;
/// * `session()` caught `APIClientException$Authorization` and `APIClientException$400`
///   — exceptions that raw `http` can never throw, so those handlers were dead.
///
/// After this, they are reachable.
Map<String, Object?> decodeAuthResponse(http.Response response) {
  final body = _decodeBody(response);

  if (isSuccessStatusCode(response.statusCode)) return body;

  final serverError = body['error'] is String ? body['error'] as String : null;
  final serverMessage = body['message'] is String ? body['message'] as String : null;
  final serverCode = body['code'] is String ? body['code'] as String : null;

  return switch (response.statusCode) {
    // Distinguished from a rejected password: the credentials may be perfectly
    // good, and the user needs to be told to wait rather than to try again.
    429 => throw APIClientException$RateLimit(
      code: 'too_many_requests',
      message: 'Too many requests.',
      statusCode: response.statusCode,
      retryAfter: _retryAfter(response.headers),
      serverCode: serverCode,
      serverError: serverError,
      serverMessage: serverMessage,
    ),
    401 || 403 => throw APIClientException$Authorization(
      code: 'unauthorized_error',
      message: 'User is not authorized.',
      statusCode: response.statusCode,
      serverCode: serverCode,
      serverError: serverError,
      serverMessage: serverMessage,
    ),
    >= 500 => throw APIClientException$Network(
      code: 'internal_server_error',
      message: 'Internal server error.',
      statusCode: response.statusCode,
      serverCode: serverCode,
      serverError: serverError,
      serverMessage: serverMessage,
    ),
    _ => throw APIClientException$400(
      code: 'client_error',
      message: 'Request failed.',
      statusCode: response.statusCode,
      serverCode: serverCode,
      serverError: serverError,
      serverMessage: serverMessage,
    ),
  };
}

/// Parses the body, or throws a typed failure rather than a `FormatException`.
///
/// An empty body is an empty map, not an error: some auth endpoints answer `204`-ish
/// with nothing, and the callers already handle a missing key.
Map<String, Object?> _decodeBody(http.Response response) {
  final raw = response.body.trim();
  if (raw.isEmpty) return const <String, Object?>{};

  try {
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, Object?>) return decoded;

    // A JSON array or scalar where an object was expected — real, and previously an
    // unhandled cast error.
    throw APIClientException$Client(
      code: 'decoding_error',
      message: 'Expected a JSON object.',
      statusCode: response.statusCode,
      error: decoded,
      data: null,
    );
  } on FormatException catch (error) {
    // An HTML error page from a proxy is the common case here.
    throw APIClientException$Client(
      code: 'decoding_error',
      message: 'Response is not valid JSON.',
      statusCode: response.statusCode,
      error: error,
      data: null,
    );
  }
}

/// `Retry-After` in seconds. Numeric only — the HTTP-date form is parsed by
/// `dart:io`, which is unavailable on web.
Duration? _retryAfter(Map<String, String> headers) {
  final raw = headers['retry-after']?.trim();
  if (raw == null || raw.isEmpty) return null;
  final seconds = int.tryParse(raw);
  return seconds == null ? null : Duration(seconds: seconds);
}
