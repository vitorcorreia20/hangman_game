import 'package:flutter_test/flutter_test.dart';

import 'package:hangman_game/main.dart';

void main() {
  testWidgets('HomeScreen é exibida como tela inicial', (WidgetTester tester) async {
    await tester.pumpWidget(const HangmanApp());
    await tester.pump();

    expect(find.text('Jogo da Forca'), findsWidgets);
    expect(find.text('Iniciar Jogo'), findsOneWidget);
    expect(find.text('Estatísticas'), findsOneWidget);
    expect(find.text('Sobre a Equipe'), findsOneWidget);
  });
}
