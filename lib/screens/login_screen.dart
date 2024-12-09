import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'menu_screen.dart';
import '../services/database_helper.dart';
import '../widgets/home_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/title_and_description.dart';
import '../styles/app_colors.dart';
import '../styles/app_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      List<Map<String, dynamic>> existingUsers =
          await DatabaseHelper().getUsers();
      Map<String, dynamic>? user = existingUsers.firstWhere(
        (user) =>
            user['email'] == _emailController.text &&
            user['password'] == _passwordController.text,
        orElse: () => {},
      );

      if (user.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login bem-sucedido!')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => MenuScreen(userId: user['id'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail ou senha incorretos!')),
        );
      }
    }
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
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              'assets/images/login_form.png',
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
                          const TitleAndDescription(
                            title: 'Bem-vindo',
                            description:
                                'Informe seu e-mail e senha para iniciar sua sessão',
                          ),
                          const SizedBox(
                              height: 90), // Espaço antes dos campos de entrada
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'E-mail',
                            validator: _validateEmail,
                            prefixIcon: const Icon(Icons.email),
                            iconColor: AppColors.iconColor,
                          ),
                          const SizedBox(height: 20), // Espaço entre os campos
                          CustomTextField(
                            controller: _passwordController,
                            labelText: 'Senha',
                            obscureText: true,
                            validator: _validatePassword,
                            prefixIcon: const Icon(Icons.lock),
                            iconColor: AppColors.iconColor,
                          ),
                          const SizedBox(height: 30), // Espaço antes do botão
                          HomeButton(
                            text: 'Login',
                            onPressed: _login,
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
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                  'Não possui cadastro? Registre-se!',
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
