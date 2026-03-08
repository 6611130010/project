import 'package:dartz/dartz.dart';
import 'package:vocabvault/core/error/failures.dart';
import 'package:vocabvault/domain/entities/vocabulary_card.dart';

abstract class VocabularyRepository {
  Future<Either<Failure, VocabularyCard>> addVocabularyCard(VocabularyCard card);
  Future<Either<Failure, List<VocabularyCard>>> getAllVocabularyCards();
  Future<Either<Failure, VocabularyCard>> getVocabularyCardById(String id);
  Future<Either<Failure, List<VocabularyCard>>> searchVocabularyCards(String query);
  Future<Either<Failure, void>> updateVocabularyCard(VocabularyCard card);
  Future<Either<Failure, void>> deleteVocabularyCard(String id);
  Future<Either<Failure, VocabularyCard>> getRandomVocabularyCard();
}
