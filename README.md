# Jogo da Forca

Integrantes:
- Vitor dos Santos Correia

Avaliação 1 - Jogo da Forca
Curso: TSC | Bloco: 5

## Breve descrição

Aplicativo do jogo da forca em Flutter. O jogador escolhe uma categoria
(Animais, Corpo humano, Esportes, Tecnologia) e uma dificuldade
(Fácil, Médio, Difícil) e tenta adivinhar a palavra ou expressão letra a
letra, acompanhando a evolução do boneco na forca a cada erro.

As palavras ficam em `assets/data/hangman_entries.json`, com resposta,
categoria, dificuldade e dica. A partida ignora acentos na validação
(chutar `A` revela `Á`, `Ã`, `Â`, mantendo a grafia original na tela),
já exibe espaços, hífens e pontuações desde o início e limita a partida
a 6 erros.

## Principais funcionalidades

- Tela inicial com seleção de categoria e dificuldade e navegação para
  jogo, estatísticas e sobre.
- Tela de jogo com forca desenhada por `CustomPainter` (6 partes),
  palavra oculta com separação visual entre palavras, teclado virtual de
  A a Z (letras tentadas desabilitadas/coloridas), botão de dica
  (1 por rodada, exibida em diálogo) e diálogo de fim de jogo com resposta
  completa, erros, uso de dica e opções de nova rodada ou voltar ao menu.
- Tela de estatísticas da sessão: total de rodadas, vitórias (quantidade
  e %), derrotas (quantidade e %), total de erros e total de dicas.
- Tela sobre com os dados da equipe e da disciplina/curso.
- Sem repetição de respostas por combinação de categoria e dificuldade
  enquanto houver palavras disponíveis.

## Tecnologias utilizadas

- Flutter 3 (stable) com Material Design.
- Dart (SDK `>=3.0.0 <4.0.0`).
- Gerência de estado com `ChangeNotifier` + `ListenableBuilder`.
- Desserialização de JSON com `dart:convert` e leitura de assets com
  `rootBundle`.

## Instruções para obtenção e execução

```bash
git clone git@github.com:vitorcorreia20/hangman_game.git
cd hangman_game
flutter pub get
flutter run
```

Para análise e testes:

```bash
dart analyze lib/
flutter test
```

## Dependências adicionais

Não há dependências além do SDK do Flutter. O `pubspec.yaml` declara
apenas:

- `flutter` (SDK) e `cupertino_icons: ^1.0.8` como dependências.
- `flutter_test` (SDK) e `flutter_lints: ^3.0.0` como dependências de
  desenvolvimento.

## Estrutura geral da aplicação

- `lib/models/`: `enums.dart` (`AnswerCategory`, `Difficulty` com rótulos
  em português) e `hangman_entry.dart` (`HangmanEntry` com
  `fromJson`).
- `lib/repositories/`: `hangman_repository.dart` (lê
  `assets/data/hangman_entries.json` via `rootBundle.loadString`).
- `lib/controllers/`: `game_controller.dart` (`GameController`,
  `ChangeNotifier` com normalização de acentos, controle de 6 erros,
  histórico sem repetição, dicas e estatísticas).
- `lib/views/`: `home_screen.dart`, `game_screen.dart`,
  `stats_screen.dart`, `about_screen.dart` e `hangman_painter.dart`.
- `lib/main.dart`: instancia `HangmanRepository` e `GameController`,
  carrega os dados com `loadEntries()` e abre a `HomeScreen` dentro de
  um `ListenableBuilder`.
- `assets/data/hangman_entries.json`: base de palavras do jogo.
- `test/widget_test.dart`: teste de fumaça da tela inicial.
