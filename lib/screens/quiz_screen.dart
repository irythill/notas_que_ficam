import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Qual é a letra que representa a nota DÓ?',
      'options': ['A', 'B', 'C', 'D'],
      'answer': 'C'
    },
    {
      'question': 'Qual é a letra que representa a nota RÉ?',
      'options': ['A', 'B', 'C', 'D'],
      'answer': 'D'
    },
    // Adicione mais perguntas conforme necessário
  ];

  int _currentQuestionIndex = 0;
  int _score = 0;

  void _answerQuestion(String selectedOption) {
    if (selectedOption == _questions[_currentQuestionIndex]['answer']) {
      _score += 1;
    }

    setState(() {
      _currentQuestionIndex += 1;
    });

    if (_currentQuestionIndex >= _questions.length) {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Resultado'),
        content:
            Text('Você acertou $_score de ${_questions.length} perguntas!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste de Conhecimento'),
      ),
      body: _currentQuestionIndex < _questions.length
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _questions[_currentQuestionIndex]['question'],
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ..._questions[_currentQuestionIndex]['options']
                      .map((option) => ElevatedButton(
                            onPressed: () => _answerQuestion(option),
                            child: Text(option),
                          ))
                      .toList(),
                ],
              ),
            )
          : const Center(
              child: Text('Parabéns! Você completou o teste.'),
            ),
    );
  }
}
