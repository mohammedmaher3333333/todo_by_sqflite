import 'package:flutter/material.dart';
import 'package:todo_by_sqflite/core/database/controller/task_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _taskTextEditingController =
      TextEditingController();
  final TextEditingController _taskTextEditingControllerUpdate =
      TextEditingController();
  late final TaskController _taskController;

  @override
  void initState() {
    super.initState();
    _taskController = TaskController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo-List-App"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    controller: _taskTextEditingController,
                    decoration: const InputDecoration(
                      label: Text('Add Task'),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _taskController.insertTask(
                        taskName: _taskTextEditingController.text);
                    _taskTextEditingController.clear();
                  },
                  child: const Text("Submit"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _taskController.selectTask();
                    setState(() {});
                  },
                  child: const Text("refresh"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          int id = _taskController.tasksData[index]['task_id'];
                          _taskTextEditingControllerUpdate.text =
                              _taskController.tasksData[index]['task_name'];
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller:
                                          _taskTextEditingControllerUpdate,
                                      decoration: const InputDecoration(
                                        label: Text('update Task'),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _taskController.updateTask(
                                                id: id,
                                                taskName:
                                                    _taskTextEditingControllerUpdate
                                                        .text);
                                            Navigator.pop(context);
                                          },
                                          child: const Text("update"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            _taskController.deleteTask(id: id);
                                            Navigator.pop(context);
                                          },
                                          child: const Text("delete"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                                '${_taskController.tasksData[index]['task_id'].toString()}   '),
                            Text(
                              _taskController.tasksData[index]['task_name']
                                  .toString(),
                            ),
                          ],
                        ),
                      ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: _taskController.tasksData.length),
            )
          ],
        ),
      ),
    );
  }
}
