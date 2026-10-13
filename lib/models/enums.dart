enum AnswerCategory { animals, humanBody, sports, technology }

enum Difficulty { easy, medium, hard }

extension AnswerCategoryX on AnswerCategory {
  String get label {
    switch (this) {
      case AnswerCategory.animals:
        return 'Animais';
      case AnswerCategory.humanBody:
        return 'Corpo humano';
      case AnswerCategory.sports:
        return 'Esportes';
      case AnswerCategory.technology:
        return 'Tecnologia';
    }
  }
}

extension DifficultyX on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.easy:
        return 'Fácil';
      case Difficulty.medium:
        return 'Médio';
      case Difficulty.hard:
        return 'Difícil';
    }
  }
}
