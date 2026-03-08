import 'dart:convert';
import 'package:vocabvault/domain/entities/vocabulary_card.dart';

class VocabularyCardModel {
  final String id;
  final String word;
  final String pronunciation;
  final String meaning;
  final String contextMeaning;
  final List<String> exampleSentences;
  final WordCategory category;
  final String originalImagePath;
  final String createdAt;
  final String updatedAt;
  final int reviewCount;
  final double confidenceScore;

  VocabularyCardModel({
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

  // Convert to Entity
  VocabularyCard toEntity() {
    return VocabularyCard(
      id: id,
      word: word,
      pronunciation: pronunciation,
      meaning: meaning,
      contextMeaning: contextMeaning,
      exampleSentences: exampleSentences,
      category: category,
      originalImagePath: originalImagePath,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      reviewCount: reviewCount,
      confidenceScore: confidenceScore,
    );
  }

  // Convert from Entity
  factory VocabularyCardModel.fromEntity(VocabularyCard entity) {
    return VocabularyCardModel(
      id: entity.id,
      word: entity.word,
      pronunciation: entity.pronunciation,
      meaning: entity.meaning,
      contextMeaning: entity.contextMeaning,
      exampleSentences: entity.exampleSentences,
      category: entity.category,
      originalImagePath: entity.originalImagePath,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      reviewCount: entity.reviewCount,
      confidenceScore: entity.confidenceScore,
    );
  }

  // From JSON (for API responses and Database)
  factory VocabularyCardModel.fromJson(Map<String, dynamic> json) {
    List<String> sentences = [];
    if (json['exampleSentences'] != null) {
      if (json['exampleSentences'] is String) {
        // Handle SQLite string storage
        try {
          sentences = List<String>.from(jsonDecode(json['exampleSentences']));
        } catch (e) {
          sentences = [];
        }
      } else if (json['exampleSentences'] is List) {
        // Handle API list response
        sentences = List<String>.from(json['exampleSentences']);
      }
    }

    return VocabularyCardModel(
      id: json['id'] as String? ?? '',
      word: json['word'] as String? ?? '',
      pronunciation: json['pronunciation'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      contextMeaning: json['contextMeaning'] as String? ?? '',
      exampleSentences: sentences,
      category: _stringToCategoryEnum(json['category'] as String? ?? 'other'),
      originalImagePath: json['originalImagePath'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: json['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
      reviewCount: json['reviewCount'] as int? ?? 0,
      confidenceScore: (json['confidenceScore'] as num? ?? 0.8).toDouble(),
    );
  }

  // To JSON (for database storage or API requests)
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'word': word,
      'pronunciation': pronunciation,
      'meaning': meaning,
      'contextMeaning': contextMeaning,
      'exampleSentences': jsonEncode(exampleSentences), // Encode List to String for SQLite
      'category': _categoryEnumToString(category),
      'originalImagePath': originalImagePath,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'reviewCount': reviewCount,
      'confidenceScore': confidenceScore,
    };
  }

  static WordCategory _stringToCategoryEnum(String value) {
    switch (value.toLowerCase()) {
      case 'noun': return WordCategory.noun;
      case 'verb': return WordCategory.verb;
      case 'adjective': return WordCategory.adjective;
      case 'adverb': return WordCategory.adverb;
      case 'preposition': return WordCategory.preposition;
      case 'conjunction': return WordCategory.conjunction;
      case 'pronoun': return WordCategory.pronoun;
      case 'determiner': return WordCategory.determiner;
      default: return WordCategory.other;
    }
  }

  static String _categoryEnumToString(WordCategory category) {
    return category.toString().split('.').last;
  }
}
