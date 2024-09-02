import 'package:todo_by_sqflite/core/database/sqflite/my_sqflite_database.dart';

class TaskController {
  List tasksData = [];

  void insertTask({required String taskName}) async {
    MySQFliteDatabase db = MySQFliteDatabase();
    await db.insertToTaskTableColumnName(taskName: taskName);
  }

  void selectTask() async {
    MySQFliteDatabase db = MySQFliteDatabase();
    tasksData = await db.selectFromTasksTable();
  }

  void updateTask({required int id, required String taskName}) async {
    MySQFliteDatabase db = MySQFliteDatabase();
    await db.updateTaskTable(id: id, taskName: taskName);
  }

  void deleteTask({required int id}) async {
    MySQFliteDatabase db = MySQFliteDatabase();
    await db.deleteFromTaskTable(id: id);
  }


}
