import 'package:dartz/dartz.dart';
import 'package:vocabvault/core/error/failures.dart';
import 'package:vocabvault/domain/repositories/gemini_repository.dart';

class AnalyzeWordUseCase {
  final GeminiRepository repository;

  AnalyzeWordUseCase({required this.repository});

  Future<Either<Failure, Map<String, dynamic>>> call(String word) {
    return repository.analyzeWord(word);
  }
}

class TranslateTextUseCase {
  final GeminiRepository repository;

  TranslateTextUseCase({required this.repository});

  Future<Either<Failure, String>> call(String text) {
    return repository.translateText(text);
  }
}
