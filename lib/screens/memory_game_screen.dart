import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import '../services/database_helper.dart';
import 'quiz_screen.dart';

class MemoryGameScreen extends StatefulWidget {
  final int userId;

  const MemoryGameScreen({super.key, required this.userId});

  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  final List<String> _cards = [
    'C',
    'D',
    'E',
    'F',
    'G',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'A',
    'B'
  ];

  late List<String> _shuffledCards;
  List<bool> _flippedCards = [];
  List<int> _selectedCards = [];
  int _score = 0;
  int _attempts = 0;
  late Timer _timer;
  int _timeElapsed = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioCache _audioCache = AudioCache(prefix: 'assets/sounds/');

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _shuffledCards = List.from(_cards)..shuffle();
    _flippedCards = List.filled(_shuffledCards.length, false);
    _selectedCards = [];
    _score = 0;
    _attempts = 0;
    _timeElapsed = 0;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeElapsed++;
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  Future<void> _flipCard(int index) async {
    setState(() {
      _flippedCards[index] = !_flippedCards[index];
      _selectedCards.add(index);
    });

    await _audioCache.play('${_shuffledCards[index]}.mp3');

    if (_selectedCards.length == 2) {
      _attempts++;
      if (_shuffledCards[_selectedCards[0]] ==
          _shuffledCards[_selectedCards[1]]) {
        setState(() {
          _score += 10;
          _selectedCards.clear();
        });
      } else {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _flippedCards[_selectedCards[0]] = false;
          _flippedCards[_selectedCards[1]] = false;
          _selectedCards.clear();
          _score = (_score - 5).clamp(0, _score);
        });
      }

      if (_flippedCards.every((flipped) => flipped)) {
        _stopTimer();
        await DatabaseHelper().updateUserPoints(widget.userId, _score);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Jogo terminado! Pontuação: $_score'),
            action: SnackBarAction(
              label: 'Teste de Conhecimento',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const QuizScreen()),
                );
              },
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Memória'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pontuação: $_score',
                    style: Theme.of(context).textTheme.bodyLarge),
                Text('Tentativas: $_attempts',
                    style: Theme.of(context).textTheme.bodyLarge),
                Text('Tempo: $_timeElapsed s',
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: _shuffledCards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (!_flippedCards[index] && _selectedCards.length < 2) {
                      _flipCard(index);
                    }
                  },
                  child: Card(
                    child: Center(
                      child: _flippedCards[index]
                          ? Text(
                              _shuffledCards[index],
                              style: const TextStyle(
                                fontFamily: 'RockSalt',
                                fontSize: 24,
                              ),
                            )
                          : const Text(
                              '?',
                              style: TextStyle(
                                fontFamily: 'RockSalt',
                                fontSize: 24,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
