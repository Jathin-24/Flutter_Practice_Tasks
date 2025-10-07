import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/task.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data = await DatabaseHelper.instance.getTasks();
    setState(() {
      tasks = data;
    });
  }

  Future<void> _addTask() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime selectedTime = DateTime.now();
    bool isRepeating = false;
    await DatabaseHelper.instance.insertTask(newTask);

// Schedule notification
    await NotificationService().scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique ID
      title: newTask.title,
      body: newTask.description,
      scheduledTime: newTask.time,
    );


    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Task"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    final now = DateTime.now();
                    selectedTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      picked.hour,
                      picked.minute,
                    );
                  }
                },
                child: const Text("Pick Time"),
              ),
              Row(
                children: [
                  const Text("Repeat Daily"),
                  Checkbox(
                    value: isRepeating,
                    onChanged: (value) {
                      setState(() {
                        isRepeating = value ?? false;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                final newTask = Task(
                  title: titleController.text,
                  description: descController.text,
                  time: selectedTime,
                  isRepeating: isRepeating,
                );
                await DatabaseHelper.instance.insertTask(newTask);
                await _loadTasks();
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tasks")),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final t = tasks[index];
          return ListTile(
            title: Text(t.title),
            subtitle: Text(
                "${t.description}\nAt: ${t.time.hour}:${t.time.minute.toString().padLeft(2, '0')}"),
            trailing: Checkbox(
              value: t.isCompleted,
              onChanged: (value) async {
                final updatedTask = Task(
                  id: t.id,
                  title: t.title,
                  description: t.description,
                  time: t.time,
                  isCompleted: value ?? false,
                  isRepeating: t.isRepeating,
                );
                await DatabaseHelper.instance.updateTask(updatedTask);
                await _loadTasks();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
