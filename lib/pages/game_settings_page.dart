import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'teams_page.dart'; // Импортируем новую страницу

class GameSettingsPage extends StatefulWidget {
  final List<String> selectedDictionaries;

  GameSettingsPage({required this.selectedDictionaries});

  @override
  _GameSettingsPageState createState() => _GameSettingsPageState();
}

class _GameSettingsPageState extends State<GameSettingsPage> {
  int wordsPerRound = 10;
  int roundTime = 60;
  bool penaltyForSkip = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      wordsPerRound = prefs.getInt('wordsPerRound') ?? 10;
      roundTime = prefs.getInt('roundTime') ?? 60;
      penaltyForSkip = prefs.getBool('penaltyForSkip') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('wordsPerRound', wordsPerRound);
    await prefs.setInt('roundTime', roundTime);
    await prefs.setBool('penaltyForSkip', penaltyForSkip);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Настройки игры')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Выбранные словари: ${widget.selectedDictionaries.join(', ')}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            // Количество слов за раунд
            Text("Количество слов за раунд:"),
            Slider(
              value: wordsPerRound.toDouble(),
              min: 5,
              max: 20,
              divisions: 3,
              label: "$wordsPerRound",
              onChanged: (value) {
                setState(() {
                  wordsPerRound = value.toInt();
                });
                _saveSettings();
              },
            ),

            // Время раунда
            Text("Время раунда (секунды):"),
            Slider(
              value: roundTime.toDouble(),
              min: 30,
              max: 120,
              divisions: 3,
              label: "$roundTime",
              onChanged: (value) {
                setState(() {
                  roundTime = value.toInt();
                });
                _saveSettings();
              },
            ),

            // Штраф за пропуск
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Штраф за пропуск:"),
                Switch(
                  value: penaltyForSkip,
                  onChanged: (value) {
                    setState(() {
                      penaltyForSkip = value;
                    });
                    _saveSettings();
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      // Кнопка "Начать игру" в правом нижнем углу
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeamsPage(), // Переход на страницу команд
            ),
          );
        },
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
