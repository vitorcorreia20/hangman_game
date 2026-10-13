import 'package:flutter/material.dart';

import 'controllers/game_controller.dart';
import 'repositories/hangman_repository.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const HangmanApp());
}

class HangmanApp extends StatefulWidget {
  const HangmanApp({super.key});

  @override
  State<HangmanApp> createState() => _HangmanAppState();
}

class _HangmanAppState extends State<HangmanApp> {
  late final HangmanRepository _repository;
  late final GameController _controller;

  @override
  void initState() {
    super.initState();
    _repository = HangmanRepository();
    _controller = GameController(repository: _repository);
    _controller.loadEntries();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Forca',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ListenableBuilder(
        listenable: _controller,
        builder: (BuildContext context, _) {
          return HomeScreen(controller: _controller);
        },
      ),
    );
  }
}
