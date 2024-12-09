import 'package:flutter/material.dart';
import '../widgets/home_button.dart';
import '../widgets/home_logo.dart';
import '../styles/app_colors.dart';
import '../styles/app_fonts.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas que ficam', style: AppTextStyles.titleSmall),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Stack(
        children: [
          Container(
            color: AppColors.primaryColor, // Definir a cor de fundo aqui
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_screen_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          const Positioned(
            top: 160, // Ajuste a posição vertical conforme necessário
            left: 0,
            right: 0,
            child: HomeLogo(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notas que ficam',
                  style: AppTextStyles.titleLarge,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Memórias sonoras que ficam na sua mente',
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 50),
                HomeButton(
                  text: 'Login',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                ),
                const SizedBox(height: 10),
                HomeButton(
                  text: 'Registrar',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  backgroundColor: Colors.transparent,
                  textColor: Colors.black,
                  borderSide: const BorderSide(color: Colors.white),
                  buttonType:
                      ButtonType.outlined, // Especificar o tipo de botão
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
