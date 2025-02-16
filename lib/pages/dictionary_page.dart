import 'package:flutter/material.dart';
import 'game_settings_page.dart'; // Подключаем страницу с настройками игры

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final List<Map<String, dynamic>> dictionaries = [
    {'name': 'Животные', 'selected': false},
    {'name': 'Еда', 'selected': false},
    {'name': 'Путешествия', 'selected': false},
  ];

  bool get isAnyDictionarySelected {
    return dictionaries.any((dict) => dict['selected'] == true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Выберите словарь')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: dictionaries.length,
        itemBuilder: (context, index) {
          return _buildDictionaryTile(dictionaries[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isAnyDictionarySelected
            ? () {
          List<String> selectedDictionaries = dictionaries
              .where((dict) => dict['selected'] == true)
              .map<String>((dict) => dict['name'] as String) // Явно указываем, что map должен возвращать String
              .toList();


          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  GameSettingsPage(selectedDictionaries: selectedDictionaries),
            ),
          );
        }
            : null,
        child: Icon(Icons.arrow_forward),
        backgroundColor: isAnyDictionarySelected ? Colors.blue : Colors.grey,
      ),
    );
  }

  Widget _buildDictionaryTile(Map<String, dynamic> dictionary) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: dictionary['selected'],
          onChanged: (value) {
            setState(() {
              dictionary['selected'] = value;
            });
          },
        ),
        title: Text(dictionary['name']),
        trailing: IconButton(
          icon: Icon(Icons.remove_red_eye),
          onPressed: () {
            print('Просмотр словаря: ${dictionary['name']}');
          },
        ),
      ),
    );
  }
}
