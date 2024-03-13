import 'package:maestro/Models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();

    // Lösche die bestehende Datenbank und erstelle sie neu
    await deleteDatabase('${dbPath}/Earthwise.db');

    return openDatabase(
      join(dbPath, 'Earthwise.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE benutzer('
          'mail TEXT PRIMARY KEY,'
          'password TEXT,'
          'username TEXT,'
          'score DOUBLE'
          ')',
        );

        await db.execute(
          'CREATE TABLE quiz('
          'quizid INTEGER PRIMARY KEY,'
          'percent INT,'
          'time INTEGER'
          ')',
        );
      },
      version: 1,
    );
  }

  Future<void> insertQuiz(int quizid, int percent, int time) async {
    final db = await database;
    await db.insert(
      'quiz',
      {
        'quizid': quizid,
        'percent': percent,
        'time': time,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

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

  Future<List<Map<String, dynamic>>?> getQuizHighscores() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'quiz',
    );

    if (results.isNotEmpty) {
      return results;
    } else {
      return null;
    }
  }

  Future<int> updateQuiz(int quizid, int percent, int time) async {
    final db = await database;
    return await db.update(
      'quiz',
      {
        'percent': percent,
        'time': time,
      },
      where: 'quizid = ?',
      whereArgs: [quizid],
    );
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'benutzer',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

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

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'benutzer',
      user.toMap(),
      where: 'mail = ?',
      whereArgs: [user.mail],
    );
  }

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
