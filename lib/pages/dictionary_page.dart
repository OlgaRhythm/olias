import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dictionary_view_page.dart';
import 'game_settings_page.dart';
import 'package:ollias/providers/game_state.dart';

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final List<Map<String, dynamic>> dictionaries = [
    {'name': 'Animals', 'selected': false},
    {'name': 'Food', 'selected': false},
    {'name': 'Travel', 'selected': false},
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedDictionaries();
  }

  bool get isAnyDictionarySelected {
    return dictionaries.any((dict) => dict['selected'] == true);
  }

  Future<void> _loadSelectedDictionaries() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> selectedDictionaries = prefs.getStringList('selectedDictionaries') ?? [];

    setState(() {
      for (var dict in dictionaries) {
        dict['selected'] = selectedDictionaries.contains(dict['name']);
      }
    });
  }

  Future<void> _saveSelectedDictionaries() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> selectedDictionaries = dictionaries
        .where((dict) => dict['selected'] == true)
        .map<String>((dict) => dict['name'] as String)
        .toList();
    await prefs.setStringList('selectedDictionaries', selectedDictionaries);
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
            ? () async {
          await _saveSelectedDictionaries();

          List<String> selectedDictionaries = dictionaries
              .where((dict) => dict['selected'] == true)
              .map<String>((dict) => dict['name'] as String)
              .toList();

          Provider.of<GameState>(context, listen: false)
              .updateSelectedDictionaries(selectedDictionaries);

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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DictionaryViewPage(dictionaryName: dictionary['name']),
              ),
            );
          },
        ),
      ),
    );
  }
}
