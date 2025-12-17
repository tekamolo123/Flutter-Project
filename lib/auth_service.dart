import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class AuthUser {
  final String nickname;
  final String email;

  const AuthUser({required this.nickname, required this.email});
}

class AuthService {
  AuthService._();

  static final Map<String, Map<String, String>> _usersByEmail = HashMap();
  static AuthUser? _currentUser;

  static AuthUser? get currentUser => _currentUser;
  static bool get isLoggedIn => _currentUser != null;

  static void logout() {
    _currentUser = null;
  }

  static String _genSalt([int length = 16]) {
  final rnd = Random.secure();
  final bytes = List<int>.generate(length, (_) => rnd.nextInt(256));
  return base64UrlEncode(bytes);
}

static String _hashPassword({required String password, required String salt}) {
  final bytes = utf8.encode('$salt:$password');
  return sha256.convert(bytes).toString();
}


  static Future<AuthUser> register({
    required String nickname,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final key = email.trim().toLowerCase();
    if (_usersByEmail.containsKey(key)) {
      throw Exception('Користувач з таким email вже існує');
    }

    final salt = _genSalt();
final passwordHash = _hashPassword(password: password, salt: salt);

    _usersByEmail[key] = {
  'nickname': nickname.trim(),
  'salt': salt,
  'passwordHash': passwordHash,
};


    return AuthUser(nickname: nickname.trim(), email: key);
  }

  static Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final key = email.trim().toLowerCase();
    final data = _usersByEmail[key];

    const msg = 'Невірний email або пароль';

    if (data == null) {
      throw Exception(msg);
    }
    final salt = data['salt']!;
final storedHash = data['passwordHash']!;
final calcHash = _hashPassword(password: password, salt: salt);

if (storedHash != calcHash) {
  throw Exception('Невірний email або пароль');
}


    _currentUser = AuthUser(nickname: data['nickname']!, email: key);
    return _currentUser!;
  }
}
