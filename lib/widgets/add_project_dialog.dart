
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/project_task_provider.dart';

class AddProjectDialog extends StatefulWidget {
  final Function(Project) onAdd;

  AddProjectDialog({required this.onAdd});

  @override
  _AddProjectDialogState createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Project'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Project Name',
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () {
            var newProject = Project(id: DateTime.now().toString(), name: _controller.text);
            widget.onAdd(newProject);
            Provider.of<TimeEntryProvider>(context, listen: false).addProject(newProject);
            _controller.clear(); // Clear the input field
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
