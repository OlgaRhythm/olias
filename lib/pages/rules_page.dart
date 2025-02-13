import 'package:flutter/material.dart';
import '../constants/strings.dart'; // Импортируем тексты

class RulesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Правила игры'),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop(); // Закрываем окно
            },
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Text(Strings.rulesText), // Используем текст из констант
      ),
    );
  }
}