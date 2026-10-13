import 'package:flutter/material.dart';

import '../controllers/game_controller.dart';
import '../models/enums.dart';
import 'about_screen.dart';
import 'game_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  final GameController controller;

  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AnswerCategory _selectedCategory = AnswerCategory.animals;
  Difficulty _selectedDifficulty = Difficulty.easy;
  bool _isStarting = false;

  Future<void> _startGame() async {
    setState(() {
      _isStarting = true;
    });
    try {
      final bool started = await widget.controller.startNewRound(
        category: _selectedCategory,
        difficulty: _selectedDifficulty,
      );
      if (!mounted) {
        return;
      }
      if (started) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => GameScreen(
              controller: widget.controller,
              category: _selectedCategory,
              difficulty: _selectedDifficulty,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Sem mais respostas disponíveis para esta combinação. Tente outra categoria ou dificuldade.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isStarting = false;
        });
      }
    }
  }

  void _openStats() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => StatsScreen(
          controller: widget.controller,
        ),
      ),
    );
  }

  void _openAbout() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const AboutScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Forca'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Escolha a categoria e a dificuldade',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<AnswerCategory>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                  items: AnswerCategory.values.map((AnswerCategory category) {
                    return DropdownMenuItem<AnswerCategory>(
                      value: category,
                      child: Text(category.label),
                    );
                  }).toList(),
                  onChanged: (AnswerCategory? value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12.0),
                DropdownButtonFormField<Difficulty>(
                  initialValue: _selectedDifficulty,
                  decoration: const InputDecoration(
                    labelText: 'Dificuldade',
                    border: OutlineInputBorder(),
                  ),
                  items: Difficulty.values.map((Difficulty difficulty) {
                    return DropdownMenuItem<Difficulty>(
                      value: difficulty,
                      child: Text(difficulty.label),
                    );
                  }).toList(),
                  onChanged: (Difficulty? value) {
                    if (value != null) {
                      setState(() {
                        _selectedDifficulty = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _isStarting ? null : _startGame,
                  child: _isStarting
                      ? const SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        )
                      : const Text('Iniciar Jogo'),
                ),
                const SizedBox(height: 12.0),
                OutlinedButton(
                  onPressed: _openStats,
                  child: const Text('Estatísticas'),
                ),
                const SizedBox(height: 12.0),
                OutlinedButton(
                  onPressed: _openAbout,
                  child: const Text('Sobre a Equipe'),
                ),
                const SizedBox(height: 16.0),
                ListenableBuilder(
                  listenable: widget.controller,
                  builder: (BuildContext context, _) {
                    if (widget.controller.isLoading) {
                      return const Text(
                        'Carregando palavras...',
                        textAlign: TextAlign.center,
                      );
                    }
                    if (widget.controller.loadError != null) {
                      return Text(
                        'Erro ao carregar: ${widget.controller.loadError}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      );
                    }
                    return Text(
                      '${widget.controller.allEntries.length} palavras carregadas',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
