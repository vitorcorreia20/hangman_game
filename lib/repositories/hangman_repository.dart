import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/hangman_entry.dart';

class HangmanRepository {
  Future<List<HangmanEntry>> loadEntries() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/hangman_entries.json',
    );
    final Map<String, dynamic> decoded =
        jsonDecode(jsonString) as Map<String, dynamic>;
    final List<dynamic> entriesJson = decoded['entries'] as List<dynamic>;
    return entriesJson
        .map((e) => HangmanEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
