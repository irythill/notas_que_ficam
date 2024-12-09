import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'memory_game_screen.dart';
import 'quiz_screen.dart';
import 'ranking_screen.dart';
import 'settings_screen.dart';
import '../services/database_helper.dart';
import '../styles/app_colors.dart';
import '../styles/app_fonts.dart';

class MenuScreen extends StatefulWidget {
  final int userId;

  const MenuScreen({super.key, required this.userId});

  @override
  MenuScreenState createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  String _nickname = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    List<Map<String, dynamic>> users = await DatabaseHelper().getUsers();
    Map<String, dynamic>? user = users.firstWhere(
      (user) => user['id'] == widget.userId,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      setState(() {
        _nickname = user['nickname'];
      });
    }
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Bem vindo, @$_nickname',
            style: AppTextStyles.titleSmall,
          ),
          const Text(
            'Menu',
            style: AppTextStyles.bodySmall,
          )
        ]),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          MemoryGameScreen(userId: widget.userId)),
                );
              },
              child: const Text('Jogar Jogo da Memória'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const QuizScreen()),
                );
              },
              child: const Text('Fazer Teste de Conhecimento'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.leaderboard),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RankingScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          SettingsScreen(userId: widget.userId),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                color: Colors.black,
                onPressed: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
