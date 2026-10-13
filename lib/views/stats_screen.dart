import 'package:flutter/material.dart';

import '../controllers/game_controller.dart';

class StatsScreen extends StatelessWidget {
  final GameController controller;

  const StatsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Estatísticas'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Total de rodadas: ${controller.roundsCompleted}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Vitórias: ${controller.wins} (${controller.winPercentage.toStringAsFixed(1)}%)',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Derrotas: ${controller.losses} (${controller.lossPercentage.toStringAsFixed(1)}%)',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Total de erros: ${controller.totalErrors}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Total de dicas utilizadas: ${controller.totalHintsUsed}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                OutlinedButton(
                  onPressed: () {
                    controller.resetSession();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Estatísticas reiniciadas.'),
                      ),
                    );
                  },
                  child: const Text('Reiniciar estatísticas'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
