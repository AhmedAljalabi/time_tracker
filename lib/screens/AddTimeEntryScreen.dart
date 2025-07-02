import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/widgets/add_project_dialog.dart';
import 'package:time_tracker/widgets/add_task_dialog.dart';
import '../providers/project_task_provider.dart';
import '../models/TimeEntry.dart';

import 'package:intl/intl.dart';


class AddTimeEntryScreen extends StatefulWidget {
  final TimeEntry? initialTimeEntry;

  const AddTimeEntryScreen({super.key, this.initialTimeEntry});

  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  late TextEditingController _totaltimeController;
  late TextEditingController _noteController;
  String? _selectedProjectId;
  String? _selectedTaskId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _totaltimeController = TextEditingController( text: widget.initialTimeEntry?.totalTime.toString() ?? '');
    _noteController =
        TextEditingController(text: widget.initialTimeEntry?.notes ?? '');
    _selectedDate = widget.initialTimeEntry?.date ?? DateTime.now();
    _selectedProjectId = widget.initialTimeEntry?.projectId;
    _selectedTaskId = widget.initialTimeEntry?.taskId;
      

  }

  @override
  Widget build(BuildContext context) {
    final timeentryProvider = Provider.of<TimeEntryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.initialTimeEntry == null ? 'Add TimeEntry' : 'Edit TimeEntry'),
            foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 54, 161, 138),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // buildProjectDropdown(TimeEntryProvider),
            // buildTaskDropdown(TimeEntryProvider),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 8.0), // Adjust the padding as needed
              child: buildProjectDropdown(timeentryProvider),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 8.0), // Adjust the padding as needed
              child: buildTaskDropdown(timeentryProvider),
            ),
            buildDateField(_selectedDate),
            buildTextField(_totaltimeController, 'Total Time (in hours)', const TextInputType.numberWithOptions(decimal: true)),
            buildTextField(_noteController, 'note', TextInputType.text),
            
          
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 54, 161, 138),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: _saveTimeEntry,
          child: const Text('Save TimeEntry'),
        ),
      ),
    );
  }
  // Helper methods for building the form elements go here (omitted for brevity)

  void _saveTimeEntry() {
    if (_totaltimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields!')));
      return;
    }

    final entry = TimeEntry(
      id: widget.initialTimeEntry?.id ??
      DateTime.now().toString(), // Assuming you generate IDs like this
      projectId: _selectedProjectId!,  
      taskId  : _selectedTaskId!,    
      date: _selectedDate,
      totalTime: double.parse(_totaltimeController.text),     
      notes: _noteController.text,
    );

    // Calling the provider to add or update the TimeEntry
    Provider.of<TimeEntryProvider>(context, listen: false)
        .addOrUpdateTimeEntry(entry);
    Navigator.pop(context);
  }

  // Helper method to build a text field
  Widget buildTextField(
      TextEditingController controller, String label, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: type,
      ),
    );
  }

// Helper method to build the date picker field
  Widget buildDateField(DateTime selectedDate) {
    return ListTile(
      title: Text("Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
    );
  }

// Helper method to build the Project dropdown
  Widget buildProjectDropdown(TimeEntryProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedProjectId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => AddProjectDialog(onAdd: (newProject) {
              setState(() {
                _selectedProjectId =
                    newProject.id; // Automatically select the new Project
                provider.addProject( 
                   newProject ); // Add to provider, assuming this method exists
                 
              });
            }),
          );
        } else {
          setState(() => _selectedProjectId = newValue);
        }
      },
      items: provider.projects.map<DropdownMenuItem<String>>((project) {
        return DropdownMenuItem<String>(
          value: project.id,
          child: Text(project.name),
        );
      }).toList()
        ..add(const DropdownMenuItem(
          value: "New",
          child: Text("Add New Project"),
        )),
      decoration: const InputDecoration(
        labelText: 'Project',
        border: OutlineInputBorder(),
      ),
    );
  }

// Helper method to build the tag dropdown
  Widget buildTaskDropdown(TimeEntryProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedTaskId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(onAdd: (newTask) {
              provider.addTask(newTask); // Assuming you have an `addTask` method.
              setState(
                  () => _selectedTaskId = newTask.id); // Update selected task ID
            }),
          );
        } else {
          setState(() => _selectedTaskId = newValue);
        }
      },
      items: provider.tasks.map<DropdownMenuItem<String>>((task) {
        return DropdownMenuItem<String>(
          value: task.id,
          child: Text(task.name),
        );
      }).toList()
        ..add(const DropdownMenuItem(
          value: "New",
          child: Text("Add New Task"),
        )),
      decoration: const InputDecoration(
        labelText: 'Task',
        border: OutlineInputBorder(),
      ),
    );
  }
}
