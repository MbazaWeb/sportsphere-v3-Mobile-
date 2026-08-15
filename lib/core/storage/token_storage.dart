import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores JWT from login/register (mobile path — see api/auth comments).
class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _key = 'ss_session_token';
  static const _expiresKey = 'ss_session_expires';

  Future<void> saveToken(String token, {String? expiresAt}) async {
    await _storage.write(key: _key, value: token);
    if (expiresAt != null) {
      await _storage.write(key: _expiresKey, value: expiresAt);
    }
  }

  Future<String?> readToken() => _storage.read(key: _key);

  Future<void> clear() async {
    await _storage.delete(key: _key);
    await _storage.delete(key: _expiresKey);
  }
}
