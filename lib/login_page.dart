import 'package:flutter/material.dart';

import 'routes.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await AuthService.login(email: _emailC.text, password: _passC.text);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вхід')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailC,
                decoration: const InputDecoration(
                  labelText: 'Електронна пошта',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'Введіть email';
                  if (!value.contains('@')) return 'Некоректний email';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passC,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) {
                  final value = v ?? '';
                  if (value.isEmpty) return 'Введіть пароль';
                  if (value.length < 6) return 'Мінімум 6 символів';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text('Увійти'),
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.register),
                child: const Text('Немає акаунта? Реєстрація'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
