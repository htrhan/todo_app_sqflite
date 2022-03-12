import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app_sqflite/model/notes_model.dart';

class NotesDatabase {
  static NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _init("todonote.db");
    return _database;
  }

  Future<Database> _init(String localpath) async {
    String path = await getDatabasesPath();

    String dbpath = join(path, localpath);

    final notesPath =
        await openDatabase(dbpath, version: 1, onCreate: _createDb);
    return notesPath;
  }

  void _createDb(Database db, int vers) {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";
    db.execute('''
CREATE TABLE $tableName(
  ${NotesTable.columnTitle} $textType,
  ${NotesTable.columnDescription} $textType,
  ${NotesTable.columnId} $idType
)
''');
  }

  Future<List<Notes>> readNotes() async {
    final db = await instance.database;
    final result = await db!.query(tableName);
    return result.map((e) => Notes.fromJson(e)).toList();
  }

  Future<int?> addNotes(Notes note) async {
    final db = await instance.database;
    final result = await db?.insert(tableName, note.toMap());
    print(result);
    return result;
  }

  Future<int?> updateNotes(Notes note) async {
    final db = await instance.database;
    final result = await db
        ?.update(tableName, note.toMap(), where: "id=?", whereArgs: [note.id]);
  }

  Future<int?> deleteNotes(int id) async {
    final db = await instance.database;
    final result = await db?.rawDelete("delete from $tableName where id=$id");

    return result;
  }

  Future closeDb(Database db) async {
    final db = await instance.database;

    db?.close();
  }
}
