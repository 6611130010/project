import 'package:dartz/dartz.dart';
import 'package:vocabvault/core/error/failures.dart';
import 'package:vocabvault/data/datasources/vocabulary_remote_data_source.dart';
import 'package:vocabvault/domain/repositories/gemini_repository.dart';

class GeminiRepositoryImpl implements GeminiRepository {
  final VocabularyRemoteDataSource remoteDataSource;

  GeminiRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> analyzeWord(String word) async {
    try {
      final result = await remoteDataSource.analyzeWord(word);
      return result;
    } catch (e) {
      return Left(GeminiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> translateText(String text) async {
    try {
      // TODO: Implement translation using Gemini
      return const Right('');
    } catch (e) {
      return Left(GeminiFailure(message: e.toString()));
    }
  }
}
