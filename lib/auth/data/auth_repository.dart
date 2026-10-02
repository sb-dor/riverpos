import 'package:l/l.dart';
import 'package:riverpos/_core/api_client.dart';
import 'package:riverpos/auth/data/auth_decoder.dart';
import 'package:riverpos/auth/models/identity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract interface class IAuthenticationRepository {
  Future<Identity?> signIn({
    required String email,
    required String password,
    required void Function(String message) onMessage,
  });

  Future<Identity?> session();

  Future<bool> logout();

  /// Ends the session locally without contacting the server — see
  /// [IAuthenticationDatasource.discardSession].
  Future<void> discardSession();
}

final class AuthRepositoryImpl implements IAuthenticationRepository {
  AuthRepositoryImpl({required this._sharedPreferences, required this._api});

  final SharedPreferences _sharedPreferences;
  final String Function() _api;

  final String _loginPath = '/user/login';
  final String _session = '/user/session';
  final String _logout = '/user/logout';

  @override
  Future<Identity?> signIn({
    required String email,
    required String password,
    required void Function(String message) onMessage,
  }) async {
    final response = await http.post(
      Uri.parse('${_api.call()}$_loginPath'),
      body: <String, Object?>{'email': email, 'password': password},
      headers: await ApiClientHeaders(sharedPreferences: _sharedPreferences)
          .headers(),
    );

    final parsedBody = decodeAuthResponse(response);

    if (parsedBody['status'] == false) {
      if (parsedBody.containsKey('message')) {
        onMessage("${parsedBody['message']}");
      }
      return null;
    }

    if (parsedBody.containsKey('user')) {
      final jsonUser = parsedBody['user'] as Map<String, Object?>;
      final token = parsedBody['token'] as String?;

      final user = User.fromJson(jsonUser);

      await _sharedPreferences.setInt('user_id', user.id);
      if (token != null) await _sharedPreferences.setString('token', token);

      if (user.warehouseId != null) {
        await _sharedPreferences.setInt('warehouse_id', user.warehouseId!);
      }
      if (user.warehouseName != null) {
        await _sharedPreferences.setString(
          'warehouse_name',
          user.warehouseName!,
        );
      }

      return user;
    }

    throw Exception("Couldn't get user due to a server error: $parsedBody");
  }

  @override
  Future<Identity?> session() async {
    try {
      final response = await http.get(
        Uri.parse('${_api.call()}$_session'),
        headers: await ApiClientHeaders(sharedPreferences: _sharedPreferences)
            .headers(),
      );

      final parsedBody = decodeAuthResponse(response);

      l.d('Session response: $parsedBody | ${response.statusCode}');

      if (parsedBody.containsKey('email')) {
        final user = User.fromJson(parsedBody);

        await _sharedPreferences.setInt('user_id', user.id);
        final allowedToChangeWarehouse = _sharedPreferences.getBool(
          'allowed_to_change_warehouse',
        );
        if (allowedToChangeWarehouse == null || allowedToChangeWarehouse) {
          //
          if (user.warehouseId != null) {
            await _sharedPreferences.setInt('warehouse_id', user.warehouseId!);
          }
          if (user.warehouseName != null) {
            await _sharedPreferences.setString(
              'warehouse_name',
              user.warehouseName!,
            );
          }
        }
        return user;
      }

      return null;
    } on APIClientException$Authorization {
      l.d('user is not authenticated');
      await _clearAuthStorage();
      rethrow;
    } on APIClientException$400 {
      await _clearAuthStorage();
      rethrow;
    }
  }

  @override
  Future<bool> logout() async {
    final response = await http.post(
      Uri.parse('${_api.call()}$_logout'),
      headers: await ApiClientHeaders(sharedPreferences: _sharedPreferences)
          .headers(),
    );

    final parsedBody = decodeAuthResponse(response);

    l.d('logout response: $parsedBody');

    if (parsedBody.containsKey('status')) {
      if (parsedBody['status'] == true) {
        await _clearAuthStorage();
        return true;
      }
      return false;
    }

    throw Exception("Can't logout user due to a server error: $parsedBody");
  }

  @override
  Future<void> discardSession() => _clearAuthStorage();

  Future<void> _clearAuthStorage() async {
    await _sharedPreferences.remove('token');
    await _sharedPreferences.remove('user_id');
    await _sharedPreferences.remove('warehouse_id');
    await _sharedPreferences.remove('warehouse_name');
    await _sharedPreferences.remove('allowed_to_change_warehouse');
  }
}
