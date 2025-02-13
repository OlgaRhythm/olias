import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DictionaryViewPage extends StatefulWidget {
  final String dictionaryName;

  DictionaryViewPage({required this.dictionaryName});

  @override
  _DictionaryViewPageState createState() => _DictionaryViewPageState();
}

class _DictionaryViewPageState extends State<DictionaryViewPage> {
  List<Map<String, String>> words = [];
  final Map<String, List<Map<String, String>>> dictionaryWords = {
    'Animals': [
      {'Elephant': 'Слон'}, {'Tiger': 'Тигр'}, {'Lion': 'Лев'},
      {'Cat': 'Кот'}, {'Dog': 'Собака'}, {'Bear': 'Медведь'},
      {'Wolf': 'Волк'}, {'Fox': 'Лиса'}, {'Deer': 'Олень'},
      {'Rabbit': 'Кролик'}, {'Horse': 'Лошадь'}, {'Cow': 'Корова'},
      {'Sheep': 'Овца'}, {'Goat': 'Коза'}, {'Chicken': 'Курица'},
      {'Duck': 'Утка'}, {'Hawk': 'Ястреб'}, {'Eagle': 'Орел'},
      {'Owl': 'Сова'}, {'Penguin': 'Пингвин'},
      // Добавь еще 80 слов
    ],
    'Food': [
      {'Apple': 'Яблоко'}, {'Banana': 'Банан'}, {'Chocolate': 'Шоколад'},
      {'Cheese': 'Сыр'}, {'Bread': 'Хлеб'}, {'Milk': 'Молоко'},
      {'Egg': 'Яйцо'}, {'Chicken': 'Курица'}, {'Beef': 'Говядина'},
      {'Fish': 'Рыба'}, {'Rice': 'Рис'}, {'Pasta': 'Макароны'},
      {'Potato': 'Картофель'}, {'Carrot': 'Морковь'}, {'Tomato': 'Томат'},
      {'Onion': 'Лук'}, {'Garlic': 'Чеснок'}, {'Strawberry': 'Клубника'},
      {'Orange': 'Апельсин'}, {'Watermelon': 'Арбуз'},
      // Добавь еще 80 слов
    ],
    'Travel': [
      {'Airplane': 'Самолет'}, {'Train': 'Поезд'}, {'Mountain': 'Гора'},
      {'Sea': 'Море'}, {'Hotel': 'Отель'}, {'Passport': 'Паспорт'},
      {'Suitcase': 'Чемодан'}, {'Ticket': 'Билет'}, {'Tourist': 'Турист'},
      {'Map': 'Карта'}, {'Taxi': 'Такси'}, {'Bus': 'Автобус'},
      {'Subway': 'Метро'}, {'Beach': 'Пляж'}, {'Island': 'Остров'},
      {'Bridge': 'Мост'}, {'Museum': 'Музей'}, {'Temple': 'Храм'},
      {'Castle': 'Замок'}, {'Forest': 'Лес'},
      // Добавь еще 80 слов
    ]
  };

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final prefs = await SharedPreferences.getInstance();
    final savedWords = prefs.getString(widget.dictionaryName);

    if (savedWords != null) {
      try {
        List<dynamic> decodedWords = json.decode(savedWords);
        setState(() {
          words = decodedWords
              .map((e) => Map<String, String>.from(e as Map))
              .toList();
        });
      } catch (e) {
        print("Ошибка загрузки словаря: $e");
        setState(() {
          words = dictionaryWords[widget.dictionaryName] ?? [];
        });
        _saveWords();
      }
    } else {
      setState(() {
        words = dictionaryWords[widget.dictionaryName] ?? [];
      });
      _saveWords();
    }
  }

  Future<void> _saveWords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(widget.dictionaryName, json.encode(words));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.dictionaryName)),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: words.length,
        itemBuilder: (context, index) {
          final entry = words[index];
          if (entry.isEmpty) {
            return ListTile(title: Text("Ошибка в данных"));
          }
          final english = entry.keys.first;
          final russian = entry[english] ?? "Нет перевода";

          return Card(
            child: ListTile(
              title: Text('$english - $russian'),
            ),
          );
        },
      ),
    );
  }
}
