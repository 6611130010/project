import 'package:dartz/dartz.dart';
import 'package:vocabvault/core/error/failures.dart';
import 'package:vocabvault/data/datasources/vocabulary_local_data_source.dart';
import 'package:vocabvault/data/models/vocabulary_card_model.dart';
import 'package:vocabvault/domain/entities/vocabulary_card.dart';
import 'package:vocabvault/domain/repositories/vocabulary_repository.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  final VocabularyLocalDataSource localDataSource;

  VocabularyRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, VocabularyCard>> addVocabularyCard(VocabularyCard card) async {
    try {
      final model = VocabularyCardModel.fromEntity(card);
      await localDataSource.addVocabularyCard(model);
      return Right(card);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVocabularyCard(String id) async {
    try {
      await localDataSource.deleteVocabularyCard(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VocabularyCard>>> getAllVocabularyCards() async {
    try {
      final models = await localDataSource.getAllVocabularyCards();
      print('Repository: Retrieved ${models.length} vocabulary card models');
      final entities = models.map((model) => model.toEntity()).toList();
      print('Repository: Converted to ${entities.length} entities');
      return Right(entities);
    } catch (e) {
      print('Repository: Error getting all vocabulary cards: $e');
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VocabularyCard>> getVocabularyCardById(String id) async {
    try {
      final model = await localDataSource.getVocabularyCardById(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VocabularyCard>> getRandomVocabularyCard() async {
    try {
      final model = await localDataSource.getRandomVocabularyCard();
      return Right(model.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VocabularyCard>>> searchVocabularyCards(String query) async {
    try {
      final models = await localDataSource.searchVocabularyCards(query);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateVocabularyCard(VocabularyCard card) async {
    try {
      final model = VocabularyCardModel.fromEntity(card);
      await localDataSource.updateVocabularyCard(model);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
