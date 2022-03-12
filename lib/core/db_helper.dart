import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

    String dbpath = join(localpath, path);

    final notesPath =
        await openDatabase(dbpath, version: 1, onCreate: _createDb);
    return notesPath;
  }

  void _createDb(Database db, int vers) {}
}
