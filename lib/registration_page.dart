import 'package:flutter/material.dart';

import 'routes.dart';
import 'auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nickC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();

  @override
  void dispose() {
    _nickC.dispose();
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await AuthService.register(
        nickname: _nickC.text,
        email: _emailC.text,
        password: _passC.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Акаунт успішно створено! Тепер увійдіть.')),
      );
      Navigator.pop(context);
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
      appBar: AppBar(title: const Text('Реєстрація')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nickC,
                decoration: const InputDecoration(
                  labelText: 'Нікнейм',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'Введіть нікнейм';
                  if (value.length < 2) return 'Занадто коротко';
                  return null;
                },
              ),
              const SizedBox(height: 12),
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
                  onPressed: _register,
                  child: const Text('Створити акаунт'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}