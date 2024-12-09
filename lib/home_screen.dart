import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

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
            color: AppColors.primaryColor, // Definir a cor de fundo
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_screen_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const SizedBox(
                  height: 160), // Ajuste a altura conforme necessário
              Center(
                child: Image.asset(
                  'assets/images/nqf_logo.png',
                  width: 250, // Ajuste o tamanho conforme necessário
                  height: 250, // Ajuste o tamanho conforme necessário
                ),
              ),
            ],
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('Login',
                        style: AppTextStyles.buttonText
                            .copyWith(color: Colors.black)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Fundo transparente
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side:
                          const BorderSide(color: Colors.white), // Borda branca
                    ),
                    child: Text('Registrar',
                        style: AppTextStyles.buttonText
                            .copyWith(color: Colors.black)),
                  ),
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
