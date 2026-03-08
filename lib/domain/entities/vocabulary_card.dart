import 'package:equatable/equatable.dart';

enum WordCategory {
  noun,
  verb,
  adjective,
  adverb,
  preposition,
  conjunction,
  pronoun,
  determiner,
  other,
}

class VocabularyCard extends Equatable {
  final String id;
  final String word;
  final String pronunciation;
  final String meaning;
  final String contextMeaning;
  final List<String> exampleSentences;
  final WordCategory category;
  final String originalImagePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int reviewCount;
  final double confidenceScore;

  const VocabularyCard({
    required this.id,
    required this.word,
    required this.pronunciation,
    required this.meaning,
    required this.contextMeaning,
    required this.exampleSentences,
    required this.category,
    required this.originalImagePath,
    required this.createdAt,
    required this.updatedAt,
    this.reviewCount = 0,
    this.confidenceScore = 0.8,
  });

  VocabularyCard copyWith({
    String? id,
    String? word,
    String? pronunciation,
    String? meaning,
    String? contextMeaning,
    List<String>? exampleSentences,
    WordCategory? category,
    String? originalImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? reviewCount,
    double? confidenceScore,
  }) {
    return VocabularyCard(
      id: id ?? this.id,
      word: word ?? this.word,
      pronunciation: pronunciation ?? this.pronunciation,
      meaning: meaning ?? this.meaning,
      contextMeaning: contextMeaning ?? this.contextMeaning,
      exampleSentences: exampleSentences ?? this.exampleSentences,
      category: category ?? this.category,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reviewCount: reviewCount ?? this.reviewCount,
      confidenceScore: confidenceScore ?? this.confidenceScore,
    );
  }

  @override
  List<Object?> get props => [
        id,
        word,
        pronunciation,
        meaning,
        contextMeaning,
        exampleSentences,
        category,
        originalImagePath,
        createdAt,
        updatedAt,
        reviewCount,
        confidenceScore,
      ];
}
