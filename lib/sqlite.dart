import 'package:medicinus/components/mdicine.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final _databaseName = "medicine.db";
  static final _databaseVersion = 1;

  static final table = 'medicine_table';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnDose = 'dose';
  static final columnTime = 'time';
  static final columnIcon = 'icon';

  // Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnDose TEXT NOT NULL,
        $columnTime TEXT NOT NULL,
        $columnIcon TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Medicine medicine) async {
    Database db = await instance.database;
    return await db.insert(table, medicine.toMap());
  }

  Future<List<Medicine>> getMedicines() async {
    Database db = await instance.database;
    var res = await db.query(table, orderBy: "$columnTime ASC");
    return res.isNotEmpty
        ? res.map((c) => Medicine.fromMap(c)).toList()
        : [];
  }

  Future<int> update(Medicine medicine) async {
    Database db = await instance.database;
    return await db.update(
      table,
      medicine.toMap(),
      where: '$columnId = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
