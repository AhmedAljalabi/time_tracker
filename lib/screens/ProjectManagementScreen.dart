
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/project_task_provider.dart';
import '../widgets/add_project_dialog.dart';

//ProjectManagementScreen
class ProjectManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Projects"),
        backgroundColor: Colors.deepPurple, // Themed color similar to your inspirations
        foregroundColor: Colors.white,
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final project = provider.projects[index];
              return ListTile(
                title: Text(project.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.deleteProject(project.id);
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
            builder: (context) => AddProjectDialog(
              onAdd: (newProject) {
                Provider.of<TimeEntryProvider>(context, listen: false).addProject(newProject);
                Navigator.pop(context); // Close the dialog
              },
            ),
          );
        },
        tooltip: 'Add New Project',
        child: Icon(Icons.add),
      ),
    );
  }
}
