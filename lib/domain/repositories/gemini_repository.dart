import 'package:dartz/dartz.dart';
import 'package:vocabvault/core/error/failures.dart';

abstract class GeminiRepository {
  Future<Either<Failure, Map<String, dynamic>>> analyzeWord(String word);
  Future<Either<Failure, String>> translateText(String text);
}
