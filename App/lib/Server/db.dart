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

// Defines an asynchronous function to initialize the database.
  Future<Database> initDatabase() async {
    // Retrieves the default database path for the application.
    final dbPath = await getDatabasesPath();

    // Deletes the existing 'Earthwise.db' database to reset data, if needed.
    await deleteDatabase('${dbPath}/Earthwise.db');

    // Opens the database, creating it if it doesn't exist.
    return openDatabase(
      // Sets the path and name for the database.
      join(dbPath, 'Earthwise.db'),
      // Defines the function to create the database structure when the database is first created.
      onCreate: (db, version) async {
        // Executes SQL to create the 'benutzer' table with specified columns.
        await db.execute(
          'CREATE TABLE benutzer('
          'mail TEXT PRIMARY KEY,' // Defines 'mail' as a text field and primary key.
          'password TEXT,' // Defines 'password' as a text field.
          'username TEXT,' // Defines 'username' as a text field.
          'score DOUBLE' // Defines 'score' as a double field.
          ')',
        );

        // Executes SQL to create the 'quiz' table with specified columns.
        await db.execute(
          'CREATE TABLE quiz('
          'quizid INTEGER PRIMARY KEY,' // Defines 'quizid' as an integer primary key.
          'percent INT,' // Defines 'percent' as an integer field.
          'time INTEGER' // Defines 'time' as an integer field.
          ')',
        );
      },
      // Sets the version of the database to 1. This is used for future schema migrations.
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

// Defines an asynchronous function to update the user's level
  Future<int> updateUserLevel(String mail, int newLevel) async {
    // Awaits to get a reference to the database
    final db = await database;

    // Performs the update operation on the 'benutzer' table
    return await db.update(
      'benutzer', // The name of the table where the update will be performed
      {'score': newLevel}, // The new value for the 'score' column
      where:
          'mail = ?', // Specifies the condition to find the right user based on email
      whereArgs: [mail], // Provides the email argument for the where condition
    );
  }
}
