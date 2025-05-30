import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = AuthService();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  void _register() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showMessage('Username dan Password tidak boleh kosong');
      return;
    }

    await _auth.register(username, password);
    _showMessage('Registrasi berhasil! Silakan login.');

    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon:
                      Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Daftar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Sudah punya akun? Login di sini'),
            ),
          ],
        ),
      ),
    );
  }
}
