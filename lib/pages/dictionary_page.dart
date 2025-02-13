import 'package:flutter/material.dart';

class DictionaryPage extends StatelessWidget {
  final String level; // Параметр уровня

  DictionaryPage({required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выберите словарь ($level)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDictionaryButton(context, 'Животные'),
            SizedBox(height: 20),
            _buildDictionaryButton(context, 'Еда'),
            SizedBox(height: 20),
            _buildDictionaryButton(context, 'Путешествия'),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Действие для создания нового словаря
                print('Создать новый словарь');
              },
              child: Text('Создать новый словарь'),
            ),
          ],
        ),
      ),
    );
  }

  // Метод для создания кнопки словаря
  Widget _buildDictionaryButton(BuildContext context, String dictionary) {
    return ElevatedButton(
      onPressed: () {
        // Действие при выборе словаря
        print('Выбран словарь: $dictionary');
      },
      child: Text(dictionary),
    );
  }
}