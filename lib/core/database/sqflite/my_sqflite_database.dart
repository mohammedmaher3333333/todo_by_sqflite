import 'package:sqflite/sqflite.dart';
import 'package:todo_by_sqflite/core/database/sqflite/crud.dart';
import 'package:sqflite/sqflite.dart' as mySqfLiteDatabase;
import 'package:path/path.dart';

class MySQFliteDatabase extends CRUD {
  final String _taskTable = 'task_table';
  final String _taskTableColumnID = 'task_id';
  final String _taskTableColumnName = 'task_name';

  Database? _db;

  // for i can initial database one
  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDatabase();
      return _db;
    } else {
      return _db;
    }
  }

  _initDatabase() async {
    var databasesPath = await mySqfLiteDatabase.getDatabasesPath();
    String path = join(databasesPath, 'todo.db');

    // open the database
    int versionDatabase = 1;
    _db ??= await mySqfLiteDatabase.openDatabase(
      path,
      version: versionDatabase,
      onCreate: _onCreate,
    );
    return _db!;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $_taskTable ($_taskTableColumnID INTEGER PRIMARY KEY AUTOINCREMENT, $_taskTableColumnName TEXT)');
  }

  // main deleted
  @override
  Future<bool> delete(
      {required String tableName, required String where}) async {
    Database? myDb=await db;
    int deleted = await myDb!.delete(tableName, where: where);
    return deleted > 0 ? true : false;
  }

  Future<bool> deleteFromTaskTable({required int id}) {
    return delete(tableName: _taskTable, where: '$_taskTableColumnID==$id');
  }

  // main insert
  @override
  Future<bool> insert(
      {required String tableName, required Map<String, Object?> values}) async {
    Database? myDb=await db;
    int inserted = await myDb!.insert(tableName, values);
    myDb.close();
    return inserted > 0 ? true : false;
  }

  // insert to task table
  Future<bool> insertToTaskTableColumnName({required String taskName}) {
    return insert(tableName: _taskTable, values: {
      _taskTableColumnName: taskName,
    });
  }

  // main function select
  @override
  Future<List<Map<String, Object?>>> select({required String tableName}) async {
    Database? myDb=await db;
    List<Map<String, Object?>> data = await myDb!.query(tableName);
    myDb.close();
    return data;
  }

  // Select in task table
  Future<List<Map<String, Object?>>> selectFromTasksTable() async {
    return select(tableName: _taskTable);
  }

  // main update
  @override
  Future<bool> update(
      {required String tableName,
      required Map<String, Object?> values,
      required String where}) async {
    Database? myDb=await db;
    int updated = await myDb!.update(tableName, values, where: where);
    myDb.close();
    return updated > 0 ? true : false;
  }

  // update task in task table
  Future<bool> updateTaskTable({required int id, required String taskName}) {
    return update(
        tableName: _taskTable,
        values: {_taskTableColumnName: taskName},
        where: '$_taskTableColumnID == $id');
  }
}
