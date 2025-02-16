import 'package:flutter/material.dart';
import 'game_page.dart'; // Импортируем страницу игры

class TeamsPage extends StatefulWidget {
  @override
  _TeamsPageState createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  List<String> teams = []; // Список команд
  final TextEditingController _controller = TextEditingController();

  void _addTeam(String name) {
    if (name.isNotEmpty) {
      setState(() {
        teams.add(name);
      });
      _controller.clear();
    }
  }

  void _editTeam(int index) {
    _controller.text = teams[index];

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
                  teams[index] = _controller.text;
                });
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
                    title: Text(teams[index]),
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
              builder: (context) => GamePage(teams: teams),
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
