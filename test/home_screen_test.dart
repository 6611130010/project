import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocabvault/presentation/bloc/vocabulary_bloc.dart';
import 'package:vocabvault/presentation/screens/home_screen.dart';
import 'package:vocabvault/domain/usecases/vocabulary_usecases.dart';

// Mock classes
class MockVocabularyBloc extends Mock implements VocabularyBloc {}

// Fakes for fallback values used by mocktail
class FakeVocabularyEvent extends Fake implements VocabularyEvent {}
class FakeVocabularyState extends Fake implements VocabularyState {}

class MockGetAllVocabularyCardsUseCase extends Mock implements GetAllVocabularyCardsUseCase {}

class MockAddVocabularyCardUseCase extends Mock implements AddVocabularyCardUseCase {}

class MockDeleteVocabularyCardUseCase extends Mock implements DeleteVocabularyCardUseCase {}

class MockSearchVocabularyCardsUseCase extends Mock implements SearchVocabularyCardsUseCase {}

class MockGetRandomVocabularyCardUseCase extends Mock implements GetRandomVocabularyCardUseCase {}

void main() {
  late MockVocabularyBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeVocabularyEvent());
    registerFallbackValue(FakeVocabularyState());
  });

  setUp(() {
    mockBloc = MockVocabularyBloc();
    // stub stream and state so BlocBuilder can subscribe
    when(() => mockBloc.stream).thenAnswer((_) => const Stream<VocabularyState>.empty());
    when(() => mockBloc.state).thenReturn(const VocabularyInitial());
    // avoid unhandled add calls
    when(() => mockBloc.add(any())).thenReturn(null);
    // ensure close returns a Future so provider dispose doesn't crash
    when(() => mockBloc.close()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<VocabularyBloc>(
        create: (_) => mockBloc,
        child: const HomeScreen(),
      ),
    );
  }

  testWidgets('HomeScreen displays welcome message', (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(const VocabularyInitial());

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.text('VocabVault'), findsOneWidget);
    expect(find.text('Welcome to VocabVault!'), findsOneWidget);
  });

  testWidgets('HomeScreen has action buttons', (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(const VocabularyInitial());

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.text('Scan Text'), findsOneWidget);
    expect(find.text('Flashcards'), findsOneWidget);
  });

  testWidgets('HomeScreen has floating action button', (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(const VocabularyInitial());

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
  });

  testWidgets('HomeScreen displays vocabulary section', (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(const VocabularyInitial());

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.text('Your Vocabulary'), findsOneWidget);
  });
}