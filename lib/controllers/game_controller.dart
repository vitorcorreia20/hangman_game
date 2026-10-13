import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/enums.dart';
import '../models/hangman_entry.dart';
import '../repositories/hangman_repository.dart';

class GameController extends ChangeNotifier {
  static const int maxErrors = 6;

  static const List<String> alphabet = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  final HangmanRepository _repository;
  final Random _random;

  GameController({HangmanRepository? repository, Random? random})
    : _repository = repository ?? HangmanRepository(),
      _random = random ?? Random();

  List<HangmanEntry> _allEntries = <HangmanEntry>[];
  bool _isLoading = false;
  String? _loadError;

  HangmanEntry? _currentEntry;
  Set<String> _guessedLetters = <String>{};
  Set<String> _usedAnswers = <String>{};

  bool _hintUsedInRound = false;
  bool _roundFinalized = false;
  bool _exhausted = false;

  int _roundsCompleted = 0;
  int _wins = 0;
  int _losses = 0;
  int _totalErrors = 0;
  int _totalHintsUsed = 0;

  List<HangmanEntry> get allEntries => List<HangmanEntry>.unmodifiable(_allEntries);
  bool get isLoading => _isLoading;
  String? get loadError => _loadError;

  HangmanEntry? get currentEntry => _currentEntry;
  String get answer => _currentEntry?.answer ?? '';
  bool get hasActiveRound => _currentEntry != null;
  bool get isExhausted => _exhausted;

  Set<String> get guessedLetters => Set<String>.unmodifiable(_guessedLetters);

  Set<String> get correctLetters {
    final Set<String> answerLetters = _normalizedAnswerLetters;
    return _guessedLetters.where((String l) => answerLetters.contains(l)).toSet();
  }

  Set<String> get wrongLetters {
    final Set<String> answerLetters = _normalizedAnswerLetters;
    return _guessedLetters.where((String l) => !answerLetters.contains(l)).toSet();
  }

  int get errors => wrongLetters.length;
  int get remainingAttempts => GameController.maxErrors - errors;
  int get hangmanStage => errors;

  bool get isHintUsed => _hintUsedInRound;

  String get currentHint {
    final HangmanEntry? entry = _currentEntry;
    if (entry == null) {
      return '';
    }
    if (entry.hints.isEmpty) {
      return '';
    }
    return entry.hints.first;
  }

  List<String> get displayCharacters {
    final HangmanEntry? entry = _currentEntry;
    if (entry == null) {
      return <String>[];
    }
    final List<String> result = <String>[];
    for (int i = 0; i < entry.answer.length; i++) {
      final String original = entry.answer[i];
      if (!GameController.isLetter(original)) {
        result.add(original);
      } else if (_guessedLetters.contains(GameController.normalizeLetter(original))) {
        result.add(original);
      } else {
        result.add('_');
      }
    }
    return result;
  }

  String get maskedAnswer => displayCharacters.join();

  bool isRevealedAt(int index) {
    final HangmanEntry? entry = _currentEntry;
    if (entry == null) {
      return false;
    }
    if (index < 0 || index >= entry.answer.length) {
      return false;
    }
    final String original = entry.answer[index];
    if (!GameController.isLetter(original)) {
      return true;
    }
    return _guessedLetters.contains(GameController.normalizeLetter(original));
  }

  bool get isWon {
    final HangmanEntry? entry = _currentEntry;
    if (entry == null) {
      return false;
    }
    for (int i = 0; i < entry.answer.length; i++) {
      final String original = entry.answer[i];
      if (!GameController.isLetter(original)) {
        continue;
      }
      if (!_guessedLetters.contains(GameController.normalizeLetter(original))) {
        return false;
      }
    }
    return true;
  }

  bool get isLost => hasActiveRound && errors >= GameController.maxErrors;
  bool get isGameOver => isWon || isLost;
  bool get isPlaying => hasActiveRound && !isGameOver;

  int get roundsCompleted => _roundsCompleted;
  int get wins => _wins;
  int get losses => _losses;
  int get totalErrors => _totalErrors;
  int get totalHintsUsed => _totalHintsUsed;

  double get winPercentage {
    if (_roundsCompleted == 0) {
      return 0.0;
    }
    return (_wins * 100.0) / _roundsCompleted;
  }

  double get lossPercentage {
    if (_roundsCompleted == 0) {
      return 0.0;
    }
    return (_losses * 100.0) / _roundsCompleted;
  }

  Set<String> get usedAnswers => Set<String>.unmodifiable(_usedAnswers);

  static String normalizeLetter(String input) {
    if (input.isEmpty) {
      return '';
    }
    final String upper = input[0].toUpperCase();
    return GameController.baseLetter(upper);
  }

  static bool isLetter(String character) {
    if (character.isEmpty) {
      return false;
    }
    final String normalized = GameController.normalizeLetter(character);
    return RegExp(r'^[A-Z]$').hasMatch(normalized);
  }

  static String baseLetter(String upperCharacter) {
    switch (upperCharacter) {
      case 'Á':
      case 'À':
      case 'Â':
      case 'Ã':
      case 'Ä':
      case 'Å':
        return 'A';
      case 'É':
      case 'È':
      case 'Ê':
      case 'Ë':
        return 'E';
      case 'Í':
      case 'Ì':
      case 'Î':
      case 'Ï':
        return 'I';
      case 'Ó':
      case 'Ò':
      case 'Ô':
      case 'Õ':
      case 'Ö':
        return 'O';
      case 'Ú':
      case 'Ù':
      case 'Û':
      case 'Ü':
        return 'U';
      case 'Ç':
        return 'C';
      case 'Ñ':
        return 'N';
      case 'Ý':
      case 'Ÿ':
        return 'Y';
      default:
        return upperCharacter;
    }
  }

  Set<String> get _normalizedAnswerLetters {
    final HangmanEntry? entry = _currentEntry;
    final Set<String> letters = <String>{};
    if (entry == null) {
      return letters;
    }
    for (int i = 0; i < entry.answer.length; i++) {
      final String original = entry.answer[i];
      if (GameController.isLetter(original)) {
        letters.add(GameController.normalizeLetter(original));
      }
    }
    return letters;
  }

  Future<void> loadEntries() async {
    _isLoading = true;
    _loadError = null;
    notifyListeners();
    try {
      _allEntries = await _repository.loadEntries();
    } catch (e) {
      _loadError = e.toString();
      _allEntries = <HangmanEntry>[];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool hasAvailableEntries(AnswerCategory category, Difficulty difficulty) {
    final List<HangmanEntry> pool = _allEntries
        .where(
          (HangmanEntry e) =>
              e.category == category && e.difficulty == difficulty,
        )
        .toList();
    if (pool.isEmpty) {
      return false;
    }
    return pool.any((HangmanEntry e) => !_usedAnswers.contains(e.answer));
  }

  Future<bool> startNewRound({
    required AnswerCategory category,
    required Difficulty difficulty,
  }) async {
    if (_allEntries.isEmpty && !_isLoading) {
      await loadEntries();
    }
    final List<HangmanEntry> available = _allEntries
        .where(
          (HangmanEntry e) =>
              e.category == category &&
              e.difficulty == difficulty &&
              !_usedAnswers.contains(e.answer),
        )
        .toList();
    if (available.isEmpty) {
      _exhausted = true;
      _currentEntry = null;
      _guessedLetters = <String>{};
      _hintUsedInRound = false;
      _roundFinalized = false;
      notifyListeners();
      return false;
    }
    final int pickedIndex = _random.nextInt(available.length);
    final HangmanEntry picked = available[pickedIndex];
    _currentEntry = picked;
    _usedAnswers.add(picked.answer);
    _guessedLetters = <String>{};
    _hintUsedInRound = false;
    _roundFinalized = false;
    _exhausted = false;
    notifyListeners();
    return true;
  }

  bool guessLetter(String rawLetter) {
    final HangmanEntry? entry = _currentEntry;
    if (entry == null) {
      return false;
    }
    if (isGameOver) {
      return false;
    }
    if (rawLetter.trim().isEmpty) {
      return false;
    }
    final String trimmed = rawLetter.trim()[0].toUpperCase();
    final String normalized = GameController.baseLetter(trimmed);
    if (!RegExp(r'^[A-Z]$').hasMatch(normalized)) {
      return false;
    }
    if (_guessedLetters.contains(normalized)) {
      return false;
    }
    _guessedLetters.add(normalized);
    if (!_normalizedAnswerLetters.contains(normalized)) {
      _totalErrors += 1;
    }
    _finalizeRoundIfOver();
    notifyListeners();
    return true;
  }

  void requestHint() {
    if (_currentEntry == null) {
      return;
    }
    if (_hintUsedInRound) {
      return;
    }
    _hintUsedInRound = true;
    _totalHintsUsed += 1;
    notifyListeners();
  }

  void resetSession() {
    _roundsCompleted = 0;
    _wins = 0;
    _losses = 0;
    _totalErrors = 0;
    _totalHintsUsed = 0;
    _usedAnswers = <String>{};
    _currentEntry = null;
    _guessedLetters = <String>{};
    _hintUsedInRound = false;
    _roundFinalized = false;
    _exhausted = false;
    notifyListeners();
  }

  void _finalizeRoundIfOver() {
    if (_roundFinalized) {
      return;
    }
    if (isWon) {
      _roundFinalized = true;
      _roundsCompleted += 1;
      _wins += 1;
    } else if (errors >= GameController.maxErrors) {
      _roundFinalized = true;
      _roundsCompleted += 1;
      _losses += 1;
    }
  }

  @visibleForTesting
  void debugSetupForTest({required HangmanEntry entry}) {
    _allEntries = <HangmanEntry>[entry];
    _currentEntry = entry;
    _usedAnswers.add(entry.answer);
    _guessedLetters = <String>{};
    _hintUsedInRound = false;
    _roundFinalized = false;
    _exhausted = false;
  }

  @visibleForTesting
  void debugSetupForTestEntries(List<HangmanEntry> entries) {
    _allEntries = List<HangmanEntry>.from(entries);
  }
}
