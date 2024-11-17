
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  final String id;
  final String email;
  final String username;

  User({
    required this.id,
    required this.email,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': email,
      'description': username,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      username: map['username'],
    );
  }
}


class DatabaseHelper {
  static const databaseName = 'user.db';
  static const databaseVersion = 1;
  static const tableName = 'user';

  static final DatabaseHelper instance = DatabaseHelper._private();
  DatabaseHelper._private();

  static Database? databaseInstance;

  Future<Database> get database async {
    if (databaseInstance != null) return databaseInstance!;

    databaseInstance = await _initDatabase();
    return databaseInstance!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);

    return await openDatabase(path, version: databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT
      )
    ''');
  }

  Future<int> insertNote(User user) async {
    Database db = await instance.database;
    return await db.insert(tableName, user.toMap());
  }
}
