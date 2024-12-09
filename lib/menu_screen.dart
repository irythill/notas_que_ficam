import 'package:flutter/material.dart';
import 'memory_game_screen.dart';
import 'quiz_screen.dart';
import 'ranking_screen.dart';
import 'database_helper.dart';
import 'login_screen.dart'; // Adicione esta linha

class MenuScreen extends StatefulWidget {
  final int userId; // Adicione o ID do usuário

  const MenuScreen({super.key, required this.userId});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
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

  Future<void> _editNickname() async {
    TextEditingController nicknameController =
        TextEditingController(text: _nickname);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Nickname'),
          content: TextField(
            controller: nicknameController,
            decoration: const InputDecoration(labelText: 'Novo Nickname'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String newNickname = nicknameController.text;
                List<Map<String, dynamic>> existingUsers =
                    await DatabaseHelper().getUsers();
                bool nicknameExists = existingUsers
                    .any((user) => user['nickname'] == newNickname);

                if (nicknameExists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nickname já está em uso!')),
                  );
                } else {
                  await DatabaseHelper()
                      .updateUserNickname(widget.userId, newNickname);
                  setState(() {
                    _nickname = newNickname;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    await DatabaseHelper().deleteUser(widget.userId);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo, $_nickname',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _editNickname,
              child: const Text('Editar Nickname'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _deleteAccount,
              child: const Text('Deletar Conta'),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const RankingScreen()),
                );
              },
              child: const Text('Ver Ranking de Pontuação'),
            ),
          ],
        ),
      ),
    );
  }
}
