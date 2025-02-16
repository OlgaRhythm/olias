import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final List<String> teams;

  GamePage({required this.teams});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _currentTeamIndex = 0;
  bool _isTimerRunning = false;
  int _seconds = 60; // Время раунда

  void _startGame() {
    setState(() {
      _isTimerRunning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentTeam = widget.teams[_currentTeamIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Игра")),
      body: Column(
        children: [
          // Полоса таймера
          LinearProgressIndicator(
            value: _isTimerRunning ? (_seconds / 60) : 1,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),

          SizedBox(height: 20),

          // Время по центру
          Text(
            "$_seconds сек.",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),

          Spacer(),

          // Карточка с командой
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "$currentTeam, ваша очередь",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          Spacer(),

          // Кнопка "Начать игру"
          ElevatedButton(
            onPressed: _isTimerRunning ? null : _startGame,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              textStyle: TextStyle(fontSize: 20),
            ),
            child: Text("Начать игру"),
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }
}
