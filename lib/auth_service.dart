import 'dart:collection';

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

    _usersByEmail[key] = {
      'nickname': nickname.trim(),
      'password': password,
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

    if (data == null) {
      throw Exception('Користувача не знайдено');
    }
    if (data['password'] != password) {
      throw Exception('Невірний пароль');
    }

    _currentUser = AuthUser(nickname: data['nickname']!, email: key);
    return _currentUser!;
  }
}
