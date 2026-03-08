import 'package:dartz/dartz.dart';
import 'package:vocabvault/core/error/failures.dart';
import 'package:vocabvault/domain/entities/vocabulary_card.dart';
import 'package:vocabvault/domain/repositories/vocabulary_repository.dart';

class AddVocabularyCardUseCase {
  final VocabularyRepository repository;

  AddVocabularyCardUseCase({required this.repository});

  Future<Either<Failure, VocabularyCard>> call(VocabularyCard card) {
    return repository.addVocabularyCard(card);
  }
}

class GetAllVocabularyCardsUseCase {
  final VocabularyRepository repository;

  GetAllVocabularyCardsUseCase({required this.repository});

  Future<Either<Failure, List<VocabularyCard>>> call() {
    return repository.getAllVocabularyCards();
  }
}

class GetVocabularyCardByIdUseCase {
  final VocabularyRepository repository;

  GetVocabularyCardByIdUseCase({required this.repository});

  Future<Either<Failure, VocabularyCard>> call(String id) {
    return repository.getVocabularyCardById(id);
  }
}

class SearchVocabularyCardsUseCase {
  final VocabularyRepository repository;

  SearchVocabularyCardsUseCase({required this.repository});

  Future<Either<Failure, List<VocabularyCard>>> call(String query) {
    return repository.searchVocabularyCards(query);
  }
}

class UpdateVocabularyCardUseCase {
  final VocabularyRepository repository;

  UpdateVocabularyCardUseCase({required this.repository});

  Future<Either<Failure, void>> call(VocabularyCard card) {
    return repository.updateVocabularyCard(card);
  }
}

class DeleteVocabularyCardUseCase {
  final VocabularyRepository repository;

  DeleteVocabularyCardUseCase({required this.repository});

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteVocabularyCard(id);
  }
}

class GetRandomVocabularyCardUseCase {
  final VocabularyRepository repository;

  GetRandomVocabularyCardUseCase({required this.repository});

  Future<Either<Failure, VocabularyCard>> call() {
    return repository.getRandomVocabularyCard();
  }
}
