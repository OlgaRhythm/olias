import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_page.dart'; // Импортируем страницу игры
import 'dart:convert'; // Для преобразования списка в JSON

class TeamsPage extends StatefulWidget {
  @override
  _TeamsPageState createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  List<Map<String, dynamic>> teams = []; // Список команд с баллами и словами
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    final prefs = await SharedPreferences.getInstance();
    String? teamsJson = prefs.getString('teams');
    if (teamsJson != null) {
      setState(() {
        teams = List<Map<String, dynamic>>.from(json.decode(teamsJson));
      });
    }
  }

  Future<void> _saveTeams() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('teams', json.encode(teams));
  }

  void _addTeam(String name) {
    if (name.isNotEmpty) {
      setState(() {
        teams.add({'name': name, 'wordsGuessed': 0, 'score': 0});
      });
      _controller.clear();
      _saveTeams();
    }
  }

  void _editTeam(int index) {
    _controller.text = teams[index]['name'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Редактировать команду"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: "Название команды"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  teams[index]['name'] = _controller.text;
                });
                _saveTeams();
                Navigator.pop(context);
              },
              child: Text("Сохранить"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Отмена"),
            ),
          ],
        );
      },
    );
  }

  void _deleteTeam(int index) {
    setState(() {
      teams.removeAt(index);
    });
    _saveTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Создание команд")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: "Введите имя команды"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addTeam(_controller.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(teams[index]['name']),
                    subtitle: Text("Слов угадано: ${teams[index]['wordsGuessed']}, Очки: ${teams[index]['score']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editTeam(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTeam(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Кнопка "Далее" для перехода на GamePage
      floatingActionButton: FloatingActionButton(
        onPressed: teams.isNotEmpty
            ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GamePage(teams: teams.map((team) => team['name'] as String).toList()),
       ),
          );
        }
            : null, // Кнопка неактивна, если нет команд
        child: Icon(Icons.arrow_forward),
        backgroundColor: teams.isNotEmpty ? Colors.blue : Colors.grey,
      ),
    );
  }
}
