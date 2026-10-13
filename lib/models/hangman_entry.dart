import 'enums.dart';

class HangmanEntry {
  final String answer;
  final AnswerCategory category;
  final Difficulty difficulty;
  final List<String> hints;

  const HangmanEntry({
    required this.answer,
    required this.category,
    required this.difficulty,
    required this.hints,
  });

  factory HangmanEntry.fromJson(Map<String, dynamic> json) {
    return HangmanEntry(
      answer: json['answer'] as String,
      category: AnswerCategory.values.byName(json['category'] as String),
      difficulty: Difficulty.values.byName(json['difficulty'] as String),
      hints: (json['hints'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }
}
