import 'package:earthwise/Datenbank/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Singleton class to manage database operations
class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  Database? _database;

  // Getter for the database instance, initializes if null
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  // Initializes the app's main database
  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'Earthwise.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE benutzer(mail TEXT PRIMARY KEY, password TEXT, username TEXT, score INT)',
        );
        await db.execute(
          'CREATE TABLE quiz(quizid INTEGER PRIMARY KEY, percent INT, time INTEGER)',
        );
      },
      version: 1,
    );
  }

  // Deletes the existing database
  Future<void> deleteDb() async {
    final dbPath = await getDatabasesPath();
    await deleteDatabase('$dbPath/Earthwise.db');
  }

  // Inserts a new quiz record
  Future<void> insertQuiz(int quizid, int percent, int time) async {
    final db = await database;
    await db.insert(
      'quiz',
      {'quizid': quizid, 'percent': percent, 'time': time},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieves a quiz by its ID
  Future<Map<String, dynamic>?> getQuizById(int quizid) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'quiz',
      where: 'quizid = ?',
      whereArgs: [quizid],
    );
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  // Retrieves the high scores for all quizzes
  Future<List<Map<String, dynamic>>?> getQuizHighscores() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query('quiz');
    if (results.isNotEmpty) {
      return results;
    } else {
      return null;
    }
  }

  // Updates a quiz record
  Future<int> updateQuiz(int quizid, int percent, int time) async {
    final db = await database;
    return await db.update(
      'quiz',
      {'percent': percent, 'time': time},
      where: 'quizid = ?',
      whereArgs: [quizid],
    );
  }

  // Inserts a new user record
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'benutzer',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieves all user records
  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('benutzer');
    return List.generate(maps.length, (i) {
      return User(
        mail: maps[i]['mail'],
        password: maps[i]['password'],
        username: maps[i]['username'],
        score: maps[i]['score'],
      );
    });
  }

  // Updates a user record
  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'benutzer',
      user.toMap(),
      where: 'mail = ?',
      whereArgs: [user.mail],
    );
  }

  // Updates a user's score
  Future<int> updateUserLevel(String mail, int newLevel) async {
    final db = await database;
    return await db.update(
      'benutzer',
      {'score': newLevel},
      where: 'mail = ?',
      whereArgs: [mail],
    );
  }
}
