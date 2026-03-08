import 'package:vocabvault/data/models/vocabulary_card_model.dart';
import 'package:vocabvault/core/utils/database_helper.dart';

abstract class VocabularyLocalDataSource {
  Future<void> addVocabularyCard(VocabularyCardModel card);
  Future<List<VocabularyCardModel>> getAllVocabularyCards();
  Future<VocabularyCardModel> getVocabularyCardById(String id);
  Future<List<VocabularyCardModel>> searchVocabularyCards(String query);
  Future<void> updateVocabularyCard(VocabularyCardModel card);
  Future<void> deleteVocabularyCard(String id);
  Future<VocabularyCardModel> getRandomVocabularyCard();
  Future<void> clearAll();
}

class VocabularyLocalDataSourceImpl implements VocabularyLocalDataSource {
  final DatabaseHelper _databaseHelper;

  VocabularyLocalDataSourceImpl(this._databaseHelper);

  @override
  Future<void> addVocabularyCard(VocabularyCardModel card) async {
    await _databaseHelper.insertVocabularyCard(card);
  }

  @override
  Future<void> clearAll() async {
    await _databaseHelper.clearAll();
  }

  @override
  Future<void> deleteVocabularyCard(String id) async {
    await _databaseHelper.deleteVocabularyCard(id);
  }

  @override
  Future<List<VocabularyCardModel>> getAllVocabularyCards() async {
    return await _databaseHelper.getAllVocabularyCards();
  }

  @override
  Future<VocabularyCardModel> getRandomVocabularyCard() async {
    final card = await _databaseHelper.getRandomVocabularyCard();
    if (card != null) {
      return card;
    }
    throw Exception('No vocabulary cards found');
  }

  @override
  Future<VocabularyCardModel> getVocabularyCardById(String id) async {
    final card = await _databaseHelper.getVocabularyCardById(id);
    if (card != null) {
      return card;
    }
    throw Exception('Vocabulary card not found');
  }

  @override
  Future<List<VocabularyCardModel>> searchVocabularyCards(String query) async {
    return await _databaseHelper.searchVocabularyCards(query);
  }

  @override
  Future<void> updateVocabularyCard(VocabularyCardModel card) async {
    await _databaseHelper.updateVocabularyCard(card);
  }
}
