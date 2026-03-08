import 'package:flutter_test/flutter_test.dart';
import 'package:vocabvault/domain/entities/vocabulary_card.dart';
import 'package:vocabvault/data/models/vocabulary_card_model.dart';

void main() {
  group('VocabularyCardModel', () {
    final testVocabularyCard = VocabularyCard(
      id: '1',
      word: 'hello',
      pronunciation: '/həˈloʊ/',
      meaning: 'used as a greeting or to begin a phone conversation',
      contextMeaning: 'A greeting used when meeting someone',
      exampleSentences: ['Hello, how are you?', 'She said hello to her friend.'],
      category: WordCategory.other,
      originalImagePath: '/path/to/image.jpg',
      createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      updatedAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      reviewCount: 5,
      confidenceScore: 0.9,
    );

    test('should convert VocabularyCard to VocabularyCardModel', () {
      // Arrange
      final model = VocabularyCardModel.fromEntity(testVocabularyCard);

      // Assert
      expect(model.id, testVocabularyCard.id);
      expect(model.word, testVocabularyCard.word);
      expect(model.pronunciation, testVocabularyCard.pronunciation);
      expect(model.meaning, testVocabularyCard.meaning);
      expect(model.contextMeaning, testVocabularyCard.contextMeaning);
      expect(model.exampleSentences, testVocabularyCard.exampleSentences);
      expect(model.category, testVocabularyCard.category);
      expect(model.originalImagePath, testVocabularyCard.originalImagePath);
      expect(model.reviewCount, testVocabularyCard.reviewCount);
      expect(model.confidenceScore, testVocabularyCard.confidenceScore);
    });

    test('should convert VocabularyCardModel back to VocabularyCard', () {
      // Arrange
      final model = VocabularyCardModel.fromEntity(testVocabularyCard);
      final entity = model.toEntity();

      // Assert
      expect(entity.id, testVocabularyCard.id);
      expect(entity.word, testVocabularyCard.word);
      expect(entity.pronunciation, testVocabularyCard.pronunciation);
      expect(entity.meaning, testVocabularyCard.meaning);
      expect(entity.contextMeaning, testVocabularyCard.contextMeaning);
      expect(entity.exampleSentences, testVocabularyCard.exampleSentences);
      expect(entity.category, testVocabularyCard.category);
      expect(entity.originalImagePath, testVocabularyCard.originalImagePath);
      expect(entity.reviewCount, testVocabularyCard.reviewCount);
      expect(entity.confidenceScore, testVocabularyCard.confidenceScore);
    });

    test('should convert to and from JSON', () {
      // Arrange
      final model = VocabularyCardModel.fromEntity(testVocabularyCard);

      // Act
      final json = model.toJson();
      final fromJson = VocabularyCardModel.fromJson(json);

      // Assert
      expect(fromJson.id, model.id);
      expect(fromJson.word, model.word);
      expect(fromJson.pronunciation, model.pronunciation);
      expect(fromJson.meaning, model.meaning);
      expect(fromJson.contextMeaning, model.contextMeaning);
      expect(fromJson.exampleSentences, model.exampleSentences);
      expect(fromJson.category, model.category);
      expect(fromJson.originalImagePath, model.originalImagePath);
      expect(fromJson.reviewCount, model.reviewCount);
      expect(fromJson.confidenceScore, model.confidenceScore);
    });
  });
}