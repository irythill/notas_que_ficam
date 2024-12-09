import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  late Future<List<Map<String, dynamic>>> _users;

  @override
  void initState() {
    super.initState();
    _users = DatabaseHelper().getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking de Pontuação'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum usuário registrado.'));
          } else {
            List<Map<String, dynamic>> sortedUsers = List.from(snapshot.data!);
            sortedUsers.sort((a, b) => b['points'].compareTo(a['points']));
            return ListView.builder(
              itemCount: sortedUsers.length,
              itemBuilder: (context, index) {
                final user = sortedUsers[index];
                return ListTile(
                  title: Text(user['nickname']),
                  trailing: Text('${user['points']} pontos'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
