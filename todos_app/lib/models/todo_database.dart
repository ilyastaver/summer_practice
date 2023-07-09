import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/models/todo_model.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();
  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT NOT NULL,
        deadline INTEGER,
        done INTEGER NOT NULL
      )
    ''');
  }



  Future<List<TodoModel>> getTodos() async {
    final db = await instance.database;
    final todosData = await db.query('todos');
    return todosData.map((data) => TodoModel.fromMap(data)).toList();
  }

  Future<void> insertTodo(TodoModel todo) async {
    final db = await instance.database;
    await db.insert('todos', todo.toMap());
  }
  Future<void> markTodoAsDone(int id) async {
    final db = await instance.database;
    await db.update(
      'todos',
      {'done': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<void> updateTodo(TodoModel todo, int todoId) async {
    final db = await instance.database;
    await db.update(
      'todos',
      todo.toUpdateMap(),
      where: 'id = ?',
      whereArgs: [todoId],
    );
  }

  Future<void> deleteTodoById(int id) async {
    final db = await instance.database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
