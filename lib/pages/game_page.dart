import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:tcard/tcard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePage extends StatefulWidget {
  final List<String> teams;

  GamePage({required this.teams});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _currentTeamIndex = 0;
  int _seconds = 60;
  int _roundTime = 60;
  int _wordsPerRound = 10;
  bool _isTimerRunning = false;
  Timer? _timer;
  List<String> words = [];
  Map<String, int> guessedWords = {};
  final TCardController _controller = TCardController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _roundTime = prefs.getInt('roundTime') ?? 60;
      _wordsPerRound = prefs.getInt('wordsPerRound') ?? 10;
      _seconds = _roundTime;
    });
    _loadWords();
  }

  Future<void> _loadWords() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> selectedDictionaries = prefs.getStringList('selectedDictionaries') ?? [];

    List<String> loadedWords = [];
    for (var dictName in selectedDictionaries) {
      String? savedWords = prefs.getString(dictName);
      if (savedWords != null) {
        try {
          List<dynamic> decodedWords = json.decode(savedWords);
          loadedWords.addAll(decodedWords.map((e) => e.keys.first as String));
        } catch (e) {
          print("Ошибка загрузки слов из $dictName: $e");
        }
      }
    }

    setState(() {
      words = _getRandomWords(loadedWords, _wordsPerRound);
    });
  }

  List<String> _getRandomWords(List<String> allWords, int count) {
    allWords.shuffle(Random());
    return allWords.take(count).toList();
  }

  void _startGame() {
    setState(() {
      _seconds = _roundTime;
      _isTimerRunning = true;
      guessedWords.clear();
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _endRound();
      }
    });
  }

  void _endRound() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Результаты раунда'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: guessedWords.entries.map((entry) => Text('${entry.key}: ${entry.value} очк.')).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _currentTeamIndex = (_currentTeamIndex + 1) % widget.teams.length;
                words = _getRandomWords(words, _wordsPerRound); // Новые слова на следующий раунд
              });
              Navigator.pop(context);
            },
            child: Text('Далее'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentTeam = widget.teams[_currentTeamIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Игра")),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: _isTimerRunning ? (_seconds / _roundTime) : 1,
            minHeight: 8,
          ),
          SizedBox(height: 20),
          Text("$_seconds сек.", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          Spacer(),
          Text("$currentTeam, ваша очередь!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Spacer(),
          if (_isTimerRunning) _buildSwipeCards(),
          if (!_isTimerRunning)
            ElevatedButton(
              onPressed: _startGame,
              child: Text("Начать игру"),
            ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSwipeCards() {
    return SizedBox(
      height: 300,
      child: TCard(
        controller: _controller,
        cards: words.map((word) => Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Text(word, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
        )).toList(),
        onForward: (index, info) {
          if (index < words.length) {
            setState(() {
              guessedWords[words[index]] = info.direction == SwipDirection.Right ? 1 : 0;
            });
          }
          if (index == words.length) {
            _endRound();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}