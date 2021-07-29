import 'package:countdown/models/countdown.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final _databaseName = "countdown.db";
  final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();

  static DatabaseHelper? _instance;
  static Database? _database;

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._privateConstructor();
    return _instance!;
  }

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE COUNTDOWN (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        TITLE TEXT,
        DATETIME INTEGER,
        COLOR TEXT,
        PHOTO BLOB,
        ISLOOP INTEGER
      )
    ''');
  }

  Future<void> saveCountdown(Countdown newCountdown) async {
    Database? db = await database;

    try {
      await db!.insert('COUNTDOWN', newCountdown.toMap());
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateCountdown(Countdown updatedCd) async {
    Database? db = await database;
    await db!.update('COUNTDOWN', updatedCd.toMap(), where: "ID = ${updatedCd.id}");
    print("update");
  }

  Future<void> deleteCountdown(int id) async {
    Database? db = await database;
    await db?.delete('COUNTDOWN', where: 'ID = $id');
  }

  Future<List<Countdown>> getListCountdown() async {
    Database? db = await database;
    var countdowns = <Countdown>[];

    var rs = await db!.query('COUNTDOWN', orderBy: 'DATETIME ASC');

    rs.forEach((map) {
      countdowns.add(Countdown.fromMap(map));
    });

    return countdowns;
  }
}
