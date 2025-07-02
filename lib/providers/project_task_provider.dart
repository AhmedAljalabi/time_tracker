import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/project.dart';
import '../models/Task.dart';
import '../models/TimeEntry.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';


class TimeEntryProvider with ChangeNotifier {
    final LocalStorage storage;

  // List of Time Entry                               
  List<TimeEntry> _entries = [];

  // List of projects
  final List<Project> _projects = [
    Project(id: '1', name: 'Project Alpha', isDefault: true),
    Project(id: '2', name: 'Project Beta', isDefault: true),
    Project(id: '3', name: 'Project Gamma', isDefault: true),
    Project(id: '4', name: 'Project 123', isDefault: true),
  ];









  // List of tasks
  final List<Task> _tasks = [
    Task(id: '1', name: 'Task A'),
    Task(id: '2', name: 'Task B'),
    Task(id: '3', name: 'Task C'),
    Task(id: '4', name: 'Task 1'),
    Task(id: '5', name: 'Task 2'),

  ];

  // Getters
  List<TimeEntry> get entries => _entries;
  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

 TimeEntryProvider(this.storage){
      _loadTimeEntryFromStorage();
 }

  String? get id => null;

void _loadTimeEntryFromStorage() async {
    // await storage.ready;
 var storedTimeEntry = storage.getItem('entries');
    if (storedTimeEntry != null) {
      _entries = List<TimeEntry>.from(
        (storedTimeEntry as List).map((item) => TimeEntry.fromJson(item)),
      );
      notifyListeners();
    }
}

  // Add an expense
  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
   _saveTimeEntryToStorage();                
    notifyListeners();
  }

void _saveTimeEntryToStorage(){
storage.setItem(
        'entries', jsonEncode(_entries.map((e) => e.toJson()).toList()));
}

 void addOrUpdateTimeEntry(TimeEntry entry) {
    int index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      // Update existing TimeEntry
      _entries[index] = entry;
    } else {
      // Add new TimeEntry
      _entries.add(entry);
    }
    _saveTimeEntryToStorage(); // Save the updated list to local storage
    notifyListeners();
  }

// delete TimeEntry
  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveTimeEntryToStorage(); // Save the updated list to local storage
    notifyListeners();
  }

// add a project
   void addProject(Project project) {
    if (!_projects.any((cat) => cat.name == project.name)) {
      _projects.add(project);
      notifyListeners();
    }
  }

// Delete a project
  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }

// Add a task
  void addTask(Task task) {
    if (!_tasks.any((t) => t.name == task.name)) {
      _tasks.add(task);
      notifyListeners();
    }
  }

  // Delete a task
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

void removeTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveTimeEntryToStorage(); // Save the updated list to local storage
    notifyListeners();
  }
}