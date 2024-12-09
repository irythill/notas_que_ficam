import 'package:flutter/material.dart';
import 'services/database_helper.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      // Verificar se o nickname já existe
      List<Map<String, dynamic>> existingUsers =
          await DatabaseHelper().getUsers();
      bool nicknameExists = existingUsers
          .any((user) => user['nickname'] == _nicknameController.text);
      bool emailExists =
          existingUsers.any((user) => user['email'] == _emailController.text);

      if (nicknameExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nickname já está em uso!')),
        );
        return;
      }

      if (emailExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail já está em uso!')),
        );
        return;
      }

      Map<String, dynamic> user = {
        'nickname': _nicknameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'points': 0, // Inicializa os pontos com 0
      };
      await DatabaseHelper().insertUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário registrado com sucesso!')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  String? _validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, informe o seu nickname!';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, informe o seu e-mail!';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, informe um e-mail válido!';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, informe a sua senha!';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: 'Nickname'),
                validator: _validateNickname,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: _validateEmail,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: _validatePassword,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
