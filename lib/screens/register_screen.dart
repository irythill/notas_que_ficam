import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../widgets/home_button.dart';
import '../widgets/custom_text_field.dart';
import 'login_screen.dart';
import '../styles/app_colors.dart';
import '../styles/app_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
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
        title: const Text('Notas que ficam', style: AppTextStyles.titleSmall),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/images/register_form.png',
              fit: BoxFit.cover,
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 140), // Espaço acima do título
                          const Text(
                            'Registrar-se',
                            style: AppTextStyles.titleLarge,
                          ),
                          const SizedBox(height: 20),
                          const SizedBox(
                            width: 220, // Define a largura do texto descritivo
                            child: Text(
                              'Para iniciar uma sessão, informe seu e-mail, nickname e senha',
                              style: AppTextStyles.bodyLarge,
                              softWrap: true, // Garante quebra de linha
                            ),
                          ),
                          const SizedBox(
                              height: 65), // Espaço antes dos campos de entrada
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'E-mail',
                            validator: _validateEmail,
                            prefixIcon: const Icon(Icons.email),
                            iconColor: AppColors.iconColor,
                          ),
                          const SizedBox(height: 10), // Espaço entre os campos
                          CustomTextField(
                            controller: _nicknameController,
                            labelText: 'Nickname',
                            obscureText: true,
                            validator: _validateNickname,
                            prefixIcon: const Icon(Icons.person),
                            iconColor: AppColors.iconColor,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _passwordController,
                            labelText: 'Senha',
                            obscureText: true,
                            validator: _validatePassword,
                            prefixIcon: const Icon(Icons.lock),
                            iconColor: AppColors.iconColor,
                          ),
                          const SizedBox(height: 10), // Espaço antes do botão
                          HomeButton(
                            text: 'Login',
                            onPressed: _register,
                            backgroundColor: AppColors.highlightColor,
                            textColor: Colors.black,
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                  'Já possui cadastro? Faça login!',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
