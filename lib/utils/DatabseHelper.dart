import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zseblecke/utils/Model.dart';

class DBhelper {
  DBhelper._privateConstructor();
  static final DBhelper instance = DBhelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'tasks.db');
    print(path);
    var tasks = await openDatabase(path, version: 1, onCreate: _onCreate);
    return tasks;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject TEXT,
        bookType TEXT,
        pageNumber TEXT,
        taskNumber TEXT,
        year TEXT,
        month TEXT,
        day TEXT
      )
    ''');
  }

  Future<List<NoteModel>> getTasks() async {
    final Database db = await database;
    final List<Map<String, dynamic>> tasks = await db.query('tasks');
    return List.generate(tasks.length, (i) {
      return NoteModel(
        id: tasks[i]['id'],
        subject: tasks[i]['subject'],
        where: tasks[i]['bookType'],
        pageNumber: tasks[i]['pageNumber'],
        taskNumber: tasks[i]['taskNumber'],
        year: tasks[i]['year'],
        month: tasks[i]['month'],
        day: tasks[i]['day'],
      );
    });
  }

  Future<int> add(NoteModel note) async {
    Database db = await instance.database;
    var result = await db.insert('tasks', note.toMap());
    return result;
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    var result = await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<List<NoteModel>> search(String query) async {
    Database db = await instance.database;
    var result = await db
        .query('tasks', where: 'subject LIKE ?', whereArgs: ['%$query%']);
    return result.map((item) => NoteModel.fromMap(item)).toList();
  }
}
