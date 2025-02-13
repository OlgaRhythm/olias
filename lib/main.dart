import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'providers/game_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'olias',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
