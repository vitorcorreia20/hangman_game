import 'package:flutter/material.dart';

import '../controllers/game_controller.dart';
import '../models/enums.dart';
import 'hangman_painter.dart';

class GameScreen extends StatefulWidget {
  final GameController controller;
  final AnswerCategory category;
  final Difficulty difficulty;

  const GameScreen({
    super.key,
    required this.controller,
    required this.category,
    required this.difficulty,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _dialogShownForGameOver = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  void _handleControllerChanged() {
    if (!mounted) {
      return;
    }
    if (widget.controller.isGameOver && !_dialogShownForGameOver) {
      _dialogShownForGameOver = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showEndDialog();
        }
      });
    }
    if (!widget.controller.isGameOver && _dialogShownForGameOver) {
      _dialogShownForGameOver = false;
    }
  }

  Future<void> _startNewRound() async {
    _dialogShownForGameOver = false;
    final bool started = await widget.controller.startNewRound(
      category: widget.category,
      difficulty: widget.difficulty,
    );
    if (!mounted) {
      return;
    }
    if (!started) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sem mais respostas disponíveis para esta categoria e dificuldade.',
          ),
        ),
      );
    }
  }

  void _showHint() {
    widget.controller.requestHint();
    final String hint = widget.controller.currentHint;
    final String message = hint.isEmpty ? 'Nenhuma dica disponível.' : hint;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dica'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _showEndDialog() {
    final GameController controller = widget.controller;
    final bool won = controller.isWon;
    final String answer = controller.answer.isEmpty
        ? controller.currentEntry?.answer ?? ''
        : controller.answer;
    final String hintText = controller.isHintUsed ? 'Sim' : 'Não';
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(won ? 'Você venceu!' : 'Você perdeu!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Resposta: $answer'),
              const SizedBox(height: 8.0),
              Text('Erros: ${controller.errors} de ${GameController.maxErrors}'),
              const SizedBox(height: 8.0),
              Text('Usou dica: $hintText'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Voltar ao Menu'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startNewRound();
              },
              child: const Text('Nova Rodada'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWordDisplay(GameController controller) {
    final List<String> chars = controller.displayCharacters;
    final List<Widget> tiles = <Widget>[];
    for (int i = 0; i < chars.length; i++) {
      final String ch = chars[i];
      if (ch == ' ') {
        tiles.add(const SizedBox(width: 16.0, height: 48.0));
      } else if (ch == '-' || ch == "'" || ch == '’') {
        tiles.add(
          Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            child: Text(
              ch,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
        );
      } else if (!GameController.isLetter(controller.answer[i])) {
        tiles.add(
          Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Text(
              ch,
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
        );
      } else {
        final bool revealed = controller.isRevealedAt(i);
        tiles.add(
          Container(
            width: 36.0,
            height: 48.0,
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: revealed ? Colors.green.shade100 : Colors.white,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Text(
              revealed ? ch : '_',
              style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    }
    return Wrap(
      alignment: WrapAlignment.center,
      children: tiles,
    );
  }

  Widget _buildKeyboard(GameController controller) {
    final Set<String> guessed = controller.guessedLetters;
    final Set<String> correct = controller.correctLetters;
    final Set<String> wrong = controller.wrongLetters;
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: GameController.alphabet.map((String letter) {
        final bool alreadyTried = guessed.contains(letter);
        Color? background;
        Color? foreground;
        if (alreadyTried && correct.contains(letter)) {
          background = Colors.green;
          foreground = Colors.white;
        } else if (alreadyTried && wrong.contains(letter)) {
          background = Colors.red.shade300;
          foreground = Colors.white;
        }
        return ElevatedButton(
          onPressed: (alreadyTried || controller.isGameOver)
              ? null
              : () {
                  controller.guessLetter(letter);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: background,
            foregroundColor: foreground,
            padding: const EdgeInsets.all(4.0),
            textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          child: Text(letter),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (BuildContext context, _) {
        final GameController controller = widget.controller;
        final String categoryLabel = controller.currentEntry?.category.label ?? widget.category.label;
        final String difficultyLabel =
            controller.currentEntry?.difficulty.label ?? widget.difficulty.label;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Partida'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Categoria: $categoryLabel  •  Dificuldade: $difficultyLabel',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12.0),
                Center(
                  child: HangmanFigure(errors: controller.errors),
                ),
                Text(
                  'Erros: ${controller.errors} de ${GameController.maxErrors}  •  Tentativas restantes: ${controller.remainingAttempts}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12.0),
                _buildWordDisplay(controller),
                const SizedBox(height: 16.0),
                _buildKeyboard(controller),
                const SizedBox(height: 12.0),
                OutlinedButton.icon(
                  onPressed: controller.hasActiveRound && !controller.isHintUsed
                      ? _showHint
                      : () {
                          final String hint = controller.currentHint;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                hint.isEmpty ? 'Nenhuma dica disponível.' : 'Dica: $hint',
                              ),
                            ),
                          );
                        },
                  icon: const Icon(Icons.lightbulb_outline),
                  label: Text(
                    controller.isHintUsed ? 'Ver dica (usada)' : 'Dica',
                  ),
                ),
                if (controller.isExhausted)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Sem mais respostas disponíveis para esta combinação.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
