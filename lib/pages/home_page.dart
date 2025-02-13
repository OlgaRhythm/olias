import 'package:flutter/material.dart';
import 'package:ollias/pages/dictionary_page.dart';
import 'rules_page.dart'; // Импортируем экран с правилами

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olias Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     // Действие для кнопки "Продолжить"
            //     print('Продолжить');
            //   },
            //   child: Text('Продолжить'),
            // ),
            // SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DictionaryPage()),
                    );
                print('Новая игра');
              },
              child: Text('Новая игра'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Открываем экран с правилами
                showDialog(
                  context: context,
                  builder: (context) => RulesPage(),
                );
              },
              child: Text('Правила'),
            ),
          ],
        ),
      ),
    );
  }
}