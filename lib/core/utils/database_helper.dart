import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:vocabvault/data/models/vocabulary_card_model.dart';

class DatabaseHelper {
  static const String _databaseName = 'vocabulary.db';
  static const int _databaseVersion = 3;

  static const String tableVocabulary = 'vocabulary_cards';
  static const String columnId = 'id';
  static const String columnWord = 'word';
  static const String columnPronunciation = 'pronunciation';
  static const String columnMeaning = 'meaning';
  static const String columnContextMeaning = 'contextMeaning';
  static const String columnExampleSentences = 'exampleSentences';
  static const String columnCategory = 'category';
  static const String columnOriginalImagePath = 'originalImagePath';
  static const String columnCreatedAt = 'createdAt';
  static const String columnUpdatedAt = 'updatedAt';
  static const String columnReviewCount = 'reviewCount';
  static const String columnConfidenceScore = 'confidenceScore';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableVocabulary (
        $columnId TEXT PRIMARY KEY,
        $columnWord TEXT NOT NULL,
        $columnPronunciation TEXT NOT NULL,
        $columnMeaning TEXT NOT NULL,
        $columnContextMeaning TEXT NOT NULL,
        $columnExampleSentences TEXT NOT NULL,
        $columnCategory TEXT NOT NULL,
        $columnOriginalImagePath TEXT NOT NULL,
        $columnCreatedAt TEXT NOT NULL,
        $columnUpdatedAt TEXT NOT NULL,
        $columnReviewCount INTEGER NOT NULL,
        $columnConfidenceScore REAL NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 3) {
      // Migration to version 3: recreate table with correct camelCase column names
      // This handles both version 1->3 and version 2->3

      // Create new table with correct schema (camelCase)
      await db.execute('''
        CREATE TABLE ${tableVocabulary}_new (
          $columnId TEXT PRIMARY KEY,
          $columnWord TEXT NOT NULL,
          $columnPronunciation TEXT NOT NULL,
          $columnMeaning TEXT NOT NULL,
          $columnContextMeaning TEXT NOT NULL,
          $columnExampleSentences TEXT NOT NULL,
          $columnCategory TEXT NOT NULL,
          $columnOriginalImagePath TEXT NOT NULL,
          $columnCreatedAt TEXT NOT NULL,
          $columnUpdatedAt TEXT NOT NULL,
          $columnReviewCount INTEGER NOT NULL,
          $columnConfidenceScore REAL NOT NULL
        )
      ''');

      // Copy data from old table to new table, mapping old snake_case to new camelCase
      // Handle different old schemas gracefully
      try {
        await db.execute('''
          INSERT INTO ${tableVocabulary}_new (
            $columnId, $columnWord, $columnPronunciation, $columnMeaning,
            $columnContextMeaning, $columnExampleSentences, $columnCategory,
            $columnOriginalImagePath, $columnCreatedAt, $columnUpdatedAt,
            $columnReviewCount, $columnConfidenceScore
          )
          SELECT
            $columnId, $columnWord, $columnPronunciation, $columnMeaning,
            COALESCE(context_meaning, contextMeaning, ''),
            COALESCE(example_sentences, exampleSentences, ''),
            $columnCategory,
            COALESCE(original_image_path, originalImagePath, ''),
            COALESCE(created_at, createdAt, ''),
            COALESCE(updated_at, updatedAt, ''),
            COALESCE(review_count, reviewCount, 0),
            COALESCE(confidence_score, confidenceScore, 0.8)
          FROM $tableVocabulary
        ''');
      } catch (e) {
        // If the above fails, try a simpler approach (some columns might not exist)
        await db.execute('''
          INSERT INTO ${tableVocabulary}_new (
            $columnId, $columnWord, $columnPronunciation, $columnMeaning,
            $columnContextMeaning, $columnExampleSentences, $columnCategory,
            $columnOriginalImagePath, $columnCreatedAt, $columnUpdatedAt,
            $columnReviewCount, $columnConfidenceScore
          )
          SELECT
            id, word, pronunciation, meaning,
            '', '', category,
            '', '', '',
            0, 0.8
          FROM $tableVocabulary
        ''');
      }

      // Drop old table and rename new table
      await db.execute('DROP TABLE $tableVocabulary');
      await db.execute('ALTER TABLE ${tableVocabulary}_new RENAME TO $tableVocabulary');
    }
  }

  Future<void> insertVocabularyCard(VocabularyCardModel card) async {
    final Database db = await database;
    await db.insert(
      tableVocabulary,
      card.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<VocabularyCardModel>> getAllVocabularyCards() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableVocabulary);
    print('DatabaseHelper: Found ${maps.length} vocabulary cards in database');
    if (maps.isNotEmpty) {
      print('DatabaseHelper: First card data: ${maps.first}');
    }
    return List.generate(maps.length, (i) {
      return VocabularyCardModel.fromJson(maps[i]);
    });
  }

  Future<VocabularyCardModel?> getVocabularyCardById(String id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableVocabulary,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return VocabularyCardModel.fromJson(maps.first);
    }
    return null;
  }

  Future<List<VocabularyCardModel>> searchVocabularyCards(String query) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableVocabulary,
      where: '$columnWord LIKE ? OR $columnMeaning LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) {
      return VocabularyCardModel.fromJson(maps[i]);
    });
  }

  Future<void> updateVocabularyCard(VocabularyCardModel card) async {
    final Database db = await database;
    await db.update(
      tableVocabulary,
      card.toJson(),
      where: '$columnId = ?',
      whereArgs: [card.id],
    );
  }

  Future<void> deleteVocabularyCard(String id) async {
    final Database db = await database;
    await db.delete(
      tableVocabulary,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<VocabularyCardModel?> getRandomVocabularyCard() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM $tableVocabulary ORDER BY RANDOM() LIMIT 1',
    );
    if (maps.isNotEmpty) {
      return VocabularyCardModel.fromJson(maps.first);
    }
    return null;
  }

  Future<void> clearAll() async {
    final Database db = await database;
    await db.delete(tableVocabulary);
  }

  Future<void> resetDatabase() async {
    final String path = join(await getDatabasesPath(), _databaseName);
    await deleteDatabase(path);
    _database = null; // Force recreation on next access
  }

  Future<void> close() async {
    final Database db = await database;
    db.close();
  }
}
