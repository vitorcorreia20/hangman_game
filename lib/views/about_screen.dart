import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre a Equipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const <Widget>[
            Text(
              'Equipe',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            // TODO: substituir pelos nomes completos de todos os integrantes.
            Text('• Vitor dos Santos Correia'),
            SizedBox(height: 16.0),
            Text(
              'Disciplina / Curso',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            // TODO: preencher com os dados da disciplina e do curso/instituição.
            Text('Disciplina: Programação Mobile'),
            Text('Curso: Técnologo em Sistema de Computação'),
          ],
        ),
      ),
    );
  }
}
