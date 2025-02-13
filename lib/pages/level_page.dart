import 'package:flutter/material.dart';
import '../constants/strings.dart';
import 'dictionary_page.dart'; // Импортируем экран выбора словаря

class LevelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выберите уровень'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLevelButton(context, 'Beginner'),
            SizedBox(height: 20),
            _buildLevelButton(context, 'Intermediate'),
            SizedBox(height: 20),
            _buildLevelButton(context, 'Advanced'),
          ],
        ),
      ),
    );
  }

  // Метод для создания кнопки с иконкой "i"
  Widget _buildLevelButton(BuildContext context, String level) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // Переход на экран выбора словаря с передачей уровня
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DictionaryPage(level: level),
              ),
            );
          },
          child: Text(level),
        ),
        SizedBox(width: 10),
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            // Показываем всплывающее окно с описанием уровня
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Уровень: $level'),
                content: Text(_getLevelDescription(level)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Закрываем окно
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // Метод для получения описания уровня
  String _getLevelDescription(String level) {
    switch (level) {
      case 'Beginner':
        return Strings.beginnerDescription;
      case 'Intermediate':
        return Strings.intermediateDescription;
      case 'Advanced':
        return Strings.advancedDescription;
      default:
        return 'Описание отсутствует';
    }
  }
}