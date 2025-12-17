import 'package:flutter_test/flutter_test.dart';
import 'package:first_flutter_project/auth_service.dart'; // <-- заміни, якщо треба

String _uniqueEmail() =>
    'user_${DateTime.now().microsecondsSinceEpoch}@test.com';

void main() {
  tearDown(() {
    // щоб стани не заважали іншим тестам
    AuthService.logout();
  });

  test('register: trims nickname and normalizes email', () async {
    final email = _uniqueEmail();

    final user = await AuthService.register(
      nickname: '  Leonid  ',
      email: '  ${email.toUpperCase()}  ',
      password: '12345',
    );

    expect(user.nickname, 'Leonid');
    expect(user.email, email); // нижній регістр + без пробілів
  });

  test('register: throws if email already exists (case-insensitive)', () async {
    final email = _uniqueEmail();

    await AuthService.register(
      nickname: 'A',
      email: email,
      password: '111',
    );

    expect(
      () => AuthService.register(
        nickname: 'B',
        email: '  ${email.toUpperCase()}  ',
        password: '222',
      ),
      throwsA(
        isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Користувач з таким email вже існує'),
        ),
      ),
    );
  });

  test('login: sets currentUser and isLoggedIn on success', () async {
    final email = _uniqueEmail();

    await AuthService.register(
      nickname: 'Nick',
      email: email,
      password: 'pass',
    );

    final user = await AuthService.login(
      email: '  ${email.toUpperCase()} ',
      password: 'pass',
    );

    expect(user.email, email);
    expect(AuthService.isLoggedIn, isTrue);
    expect(AuthService.currentUser, isNotNull);
    expect(AuthService.currentUser!.email, email);
  });

  test('login: throws if user not found', () async {
    final email = _uniqueEmail();

    expect(
      () => AuthService.login(email: email, password: 'x'),
      throwsA(
        isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Користувача не знайдено'),
        ),
      ),
    );
  });

  test('login: throws if password is wrong', () async {
    final email = _uniqueEmail();

    await AuthService.register(
      nickname: 'Nick',
      email: email,
      password: 'right',
    );

    expect(
      () => AuthService.login(email: email, password: 'wrong'),
      throwsA(
        isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Невірний пароль'),
        ),
      ),
    );
  });

  test('logout: clears currentUser and isLoggedIn', () async {
    final email = _uniqueEmail();

    await AuthService.register(
      nickname: 'Nick',
      email: email,
      password: 'pass',
    );

    await AuthService.login(email: email, password: 'pass');
    expect(AuthService.isLoggedIn, isTrue);

    AuthService.logout();
    expect(AuthService.isLoggedIn, isFalse);
    expect(AuthService.currentUser, isNull);
  });
}
