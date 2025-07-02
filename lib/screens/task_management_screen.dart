import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/widgets/add_task_dialog.dart';
import '../providers/project_task_provider.dart';

class TaskManagementScreen extends StatelessWidget {
  const TaskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Tasks"),
        backgroundColor: Colors.deepPurple, // Themed color similar to your inspirations
        foregroundColor: Colors.white,
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              return ListTile(
                title: Text(task.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Delete the tag
                    provider.deleteTask(task.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(
              onAdd: (newTask) {
                Provider.of<TimeEntryProvider>(context, listen: false).addTask(newTask);
                Navigator.pop(context); // Close the dialog after adding the new tag
              },
            ),
          );
        },
        tooltip: 'Add New Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
