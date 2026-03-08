import 'package:get_it/get_it.dart';
import 'package:vocabvault/core/utils/database_helper.dart';
import 'package:vocabvault/data/datasources/vocabulary_local_data_source.dart';
import 'package:vocabvault/data/datasources/vocabulary_remote_data_source.dart';
import 'package:vocabvault/data/repositories/vocabulary_repository_impl.dart';
import 'package:vocabvault/data/repositories/gemini_repository_impl.dart';
import 'package:vocabvault/domain/repositories/vocabulary_repository.dart';
import 'package:vocabvault/domain/repositories/gemini_repository.dart';
import 'package:vocabvault/domain/usecases/vocabulary_usecases.dart';
import 'package:vocabvault/domain/usecases/gemini_usecases.dart';
import 'package:vocabvault/presentation/bloc/vocabulary_bloc.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  // Database Helper
  getIt.registerSingleton<DatabaseHelper>(DatabaseHelper.instance);

  // Data Sources
  getIt.registerSingleton<VocabularyLocalDataSource>(
    VocabularyLocalDataSourceImpl(getIt<DatabaseHelper>()),
  );
  getIt.registerSingleton<VocabularyRemoteDataSource>(
    VocabularyRemoteDataSourceImpl(),
  );

  // Repositories
  getIt.registerSingleton<VocabularyRepository>(
    VocabularyRepositoryImpl(
      localDataSource: getIt<VocabularyLocalDataSource>(),
    ),
  );
  getIt.registerSingleton<GeminiRepository>(
    GeminiRepositoryImpl(
      remoteDataSource: getIt<VocabularyRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerSingleton<AddVocabularyCardUseCase>(
    AddVocabularyCardUseCase(repository: getIt<VocabularyRepository>()),
  );
  getIt.registerSingleton<GetAllVocabularyCardsUseCase>(
    GetAllVocabularyCardsUseCase(repository: getIt<VocabularyRepository>()),
  );
  getIt.registerSingleton<GetVocabularyCardByIdUseCase>(
    GetVocabularyCardByIdUseCase(repository: getIt<VocabularyRepository>()),
  );
  getIt.registerSingleton<SearchVocabularyCardsUseCase>(
    SearchVocabularyCardsUseCase(repository: getIt<VocabularyRepository>()),
  );
  getIt.registerSingleton<UpdateVocabularyCardUseCase>(
    UpdateVocabularyCardUseCase(repository: getIt<VocabularyRepository>()),
  );
  getIt.registerSingleton<DeleteVocabularyCardUseCase>(
    DeleteVocabularyCardUseCase(repository: getIt<VocabularyRepository>()),
  );
  getIt.registerSingleton<GetRandomVocabularyCardUseCase>(
    GetRandomVocabularyCardUseCase(repository: getIt<VocabularyRepository>()),
  );

  getIt.registerSingleton<AnalyzeWordUseCase>(
    AnalyzeWordUseCase(repository: getIt<GeminiRepository>()),
  );
  getIt.registerSingleton<TranslateTextUseCase>(
    TranslateTextUseCase(repository: getIt<GeminiRepository>()),
  );

  // BLoCs
  getIt.registerSingleton<VocabularyBloc>(
    VocabularyBloc(
      getAllVocabularyCardsUseCase: getIt<GetAllVocabularyCardsUseCase>(),
      addVocabularyCardUseCase: getIt<AddVocabularyCardUseCase>(),
      deleteVocabularyCardUseCase: getIt<DeleteVocabularyCardUseCase>(),
      searchVocabularyCardsUseCase: getIt<SearchVocabularyCardsUseCase>(),
      getRandomVocabularyCardUseCase: getIt<GetRandomVocabularyCardUseCase>(),
      analyzeWordUseCase: getIt<AnalyzeWordUseCase>(),
    ),
  );
}
