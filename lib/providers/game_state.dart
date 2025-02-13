import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  List<String> _selectedDictionaries = [];

  final Map<String, List<String>> dictionaryWords = {
    'Животные': ['Слон', 'Тигр', 'Лев', 'Кот', 'Собака'],
    'Еда': ['Яблоко', 'Банан', 'Шоколад', 'Сыр', 'Хлеб'],
    'Путешествия': ['Самолет', 'Поезд', 'Гора', 'Море', 'Отель'],
  };

  List<String> get selectedDictionaries => _selectedDictionaries;

  void updateSelectedDictionaries(List<String> dictionaries) {
    _selectedDictionaries = dictionaries;
    notifyListeners();
  }

  List<String> getWordsForGame() {
    List<String> words = [];
    for (var dict in _selectedDictionaries) {
      words.addAll(dictionaryWords[dict] ?? []);
    }
    return words;
  }
}
