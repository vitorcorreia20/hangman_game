# Avaliação 1 - Jogo da Forca

- **Curso:** TSC
- **Bloco:** 5
- **Integrante:** Vitor dos Santos Correia

## Sobre o projeto

Aplicativo do jogo da forca em Flutter. O jogador escolhe uma categoria
(Animais, Corpo humano, Esportes, Tecnologia) e uma dificuldade
(Fácil, Médio, Difícil), tenta adivinhar a palavra ou expressão letra a letra
e acompanha a evolução do boneco na forca a cada erro.

As palavras ficam em `assets/data/hangman_entries.json`, com resposta,
categoria, dificuldade e dica. A partida tolera acentos (chutar `A` revela
`Á`, `Ã`, `Â`), já exibe espaços, hífens e pontuações desde o início e
limita a partida a 6 erros.

## Funcionalidades

- Tela inicial com seleção de categoria e dificuldade.
- Tela de jogo com forca desenhada por `CustomPainter`, palavra oculta,
  teclado virtual de A a Z, botão de dica (1 por rodada) e diálogo de
  vitória/derrota com as opções de nova rodada ou voltar ao menu.
- Tela de estatísticas da sessão: rodadas, vitórias (qtd e %),
  derrotas (qtd e %), total de erros e total de dicas.
- Tela sobre com os dados da equipe e da disciplina/curso.
- Sem repetição de respostas por combinação de categoria e dificuldade
  enquanto houver palavras disponíveis.

## Estrutura

- `lib/models/`: `enums.dart` (`AnswerCategory`, `Difficulty`) e
  `hangman_entry.dart` (`HangmanEntry`).
- `lib/repositories/`: `hangman_repository.dart` (leitura do JSON via
  `rootBundle`).
- `lib/controllers/`: `game_controller.dart` (`ChangeNotifier` com regras
  da partida e estatísticas).
- `lib/views/`: `home_screen.dart`, `game_screen.dart`, `stats_screen.dart`,
  `about_screen.dart` e `hangman_painter.dart`.
- `lib/main.dart`: instancia o repositório e o controller, carrega os dados
  e abre a `HomeScreen`.

## Como executar

```bash
flutter pub get
flutter run
```