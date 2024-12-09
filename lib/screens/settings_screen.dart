import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../styles/app_colors.dart';
import '../styles/app_fonts.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  final int userId;

  const SettingsScreen({super.key, required this.userId});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    Map<String, dynamic>? user = await DatabaseHelper().getUser(widget.userId);
    if (user != null) {
      setState(() {
        _nicknameController.text = user['nickname'];
      });
    }
  }

  Future<void> _updateNickname() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper()
          .updateUser(widget.userId, {'nickname': _nicknameController.text});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nickname atualizado com sucesso!')),
      );
    }
  }

  Future<void> _deleteAccount() async {
    await DatabaseHelper().deleteUser(widget.userId);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  String? _validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, informe o seu nickname!';
    }
    return null;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações', style: AppTextStyles.titleSmall),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Editar Nickname',
                style: AppTextStyles.titleLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: 'Nickname'),
                validator: _validateNickname,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateNickname,
                child: const Text('Atualizar Nickname'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _deleteAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Excluir Conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
