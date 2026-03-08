import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vocabvault/domain/entities/vocabulary_card.dart';
import 'package:vocabvault/domain/usecases/vocabulary_usecases.dart';
import 'package:vocabvault/domain/usecases/gemini_usecases.dart';
import 'package:uuid/uuid.dart';

// Events
abstract class VocabularyEvent extends Equatable {
  const VocabularyEvent();

  @override
  List<Object?> get props => [];
}

class GetAllVocabularyCardsEvent extends VocabularyEvent {
  const GetAllVocabularyCardsEvent();
}

class AddVocabularyCardEvent extends VocabularyEvent {
  final VocabularyCard card;

  const AddVocabularyCardEvent(this.card);

  @override
  List<Object?> get props => [card];
}

class DeleteVocabularyCardEvent extends VocabularyEvent {
  final String id;

  const DeleteVocabularyCardEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchVocabularyCardsEvent extends VocabularyEvent {
  final String query;

  const SearchVocabularyCardsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class GetRandomVocabularyCardEvent extends VocabularyEvent {
  const GetRandomVocabularyCardEvent();
}

class AnalyzeWordEvent extends VocabularyEvent {
  final String word;

  const AnalyzeWordEvent(this.word);

  @override
  List<Object?> get props => [word];
}

// States
abstract class VocabularyState extends Equatable {
  const VocabularyState();

  @override
  List<Object?> get props => [];
}

class VocabularyInitial extends VocabularyState {
  const VocabularyInitial();
}

class VocabularyLoading extends VocabularyState {
  const VocabularyLoading();
}

class VocabularyLoaded extends VocabularyState {
  final List<VocabularyCard> cards;

  const VocabularyLoaded(this.cards);

  @override
  List<Object?> get props => [cards];
}

class VocabularyError extends VocabularyState {
  final String message;

  const VocabularyError(this.message);

  @override
  List<Object?> get props => [message];
}

class VocabularyCardAdded extends VocabularyState {
  final VocabularyCard card;

  const VocabularyCardAdded(this.card);

  @override
  List<Object?> get props => [card];
}

class VocabularyCardDeleted extends VocabularyState {
  const VocabularyCardDeleted();
}

class WordAnalyzed extends VocabularyState {
  final Map<String, dynamic> analysis;

  const WordAnalyzed(this.analysis);

  @override
  List<Object?> get props => [analysis];
}

// BLoC
class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  final GetAllVocabularyCardsUseCase getAllVocabularyCardsUseCase;
  final AddVocabularyCardUseCase addVocabularyCardUseCase;
  final DeleteVocabularyCardUseCase deleteVocabularyCardUseCase;
  final SearchVocabularyCardsUseCase searchVocabularyCardsUseCase;
  final GetRandomVocabularyCardUseCase getRandomVocabularyCardUseCase;
  final AnalyzeWordUseCase analyzeWordUseCase;

  VocabularyBloc({
    required this.getAllVocabularyCardsUseCase,
    required this.addVocabularyCardUseCase,
    required this.deleteVocabularyCardUseCase,
    required this.searchVocabularyCardsUseCase,
    required this.getRandomVocabularyCardUseCase,
    required this.analyzeWordUseCase,
  }) : super(const VocabularyInitial()) {
    on<GetAllVocabularyCardsEvent>(_onGetAllVocabularyCards);
    on<AddVocabularyCardEvent>(_onAddVocabularyCard);
    on<DeleteVocabularyCardEvent>(_onDeleteVocabularyCard);
    on<SearchVocabularyCardsEvent>(_onSearchVocabularyCards);
    on<GetRandomVocabularyCardEvent>(_onGetRandomVocabularyCard);
    on<AnalyzeWordEvent>(_onAnalyzeWord);
  }

  Future<void> _onGetAllVocabularyCards(
    GetAllVocabularyCardsEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    print('Bloc: Handling GetAllVocabularyCardsEvent');
    emit(const VocabularyLoading());
    final result = await getAllVocabularyCardsUseCase();
    result.fold(
      (failure) {
        print('Bloc: GetAllVocabularyCards failed: ${failure.message}');
        emit(VocabularyError(failure.message));
      },
      (cards) {
        print('Bloc: GetAllVocabularyCards success: ${cards.length} cards');
        emit(VocabularyLoaded(cards));
      },
    );
  }

  Future<void> _onAnalyzeWord(
    AnalyzeWordEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    emit(const VocabularyLoading());
    final result = await analyzeWordUseCase(event.word);
    result.fold(
      (failure) => emit(VocabularyError(failure.message)),
      (analysis) {
        emit(WordAnalyzed(analysis));
        // แปลง JSON เป็น VocabularyCard และบันทึก
        try {
          final card = VocabularyCard(
            id: const Uuid().v4(),
            word: analysis['word'] ?? event.word,
            pronunciation: analysis['pronunciation'] ?? '',
            meaning: analysis['meaning'] ?? '',
            contextMeaning: analysis['contextMeaning'] ?? '',
            exampleSentences: List<String>.from(analysis['exampleSentences'] ?? []),
            category: _stringToCategoryEnum(analysis['category'] ?? 'other'),
            originalImagePath: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          add(AddVocabularyCardEvent(card));
        } catch (e) {
          emit(VocabularyError('Failed to parse card: $e'));
        }
      },
    );
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

  Future<void> _onAddVocabularyCard(
    AddVocabularyCardEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    final result = await addVocabularyCardUseCase(event.card);
    result.fold(
      (failure) => emit(VocabularyError(failure.message)),
      (card) {
        emit(VocabularyCardAdded(card));
        add(const GetAllVocabularyCardsEvent());
      },
    );
  }

  Future<void> _onDeleteVocabularyCard(
    DeleteVocabularyCardEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    final result = await deleteVocabularyCardUseCase(event.id);
    result.fold(
      (failure) => emit(VocabularyError(failure.message)),
      (_) {
        emit(const VocabularyCardDeleted());
        add(const GetAllVocabularyCardsEvent());
      },
    );
  }

  Future<void> _onSearchVocabularyCards(
    SearchVocabularyCardsEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    emit(const VocabularyLoading());
    final result = await searchVocabularyCardsUseCase(event.query);
    result.fold(
      (failure) => emit(VocabularyError(failure.message)),
      (cards) => emit(VocabularyLoaded(cards)),
    );
  }

  Future<void> _onGetRandomVocabularyCard(
    GetRandomVocabularyCardEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    emit(const VocabularyLoading());
    final result = await getRandomVocabularyCardUseCase();
    result.fold(
      (failure) => emit(VocabularyError(failure.message)),
      (card) => emit(VocabularyLoaded([card])),
    );
  }
}
