
class TimeEntry {
  final String id;
  final String projectId; // This will link to projects
  final String taskId; // This assumes you have a task . Adjust if needed.
  final double totalTime;
  final DateTime date;
  final String notes;

  TimeEntry({
    required this.id,
    required this.projectId,
    required this.taskId,
    required this.totalTime,
    required this.date,
    required this.notes,
    
  });

  // Convert a JSON object to an Expense instance
  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'],
      projectId: json['projectId'],
      taskId: json['taskId'],
      totalTime: json['totalTime'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
      
    );
  }

  get value => null;
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'taskId': taskId,
      'totalTime': totalTime,
      'date': date.toIso8601String(),
      'notes': notes,
      
    };
  }
}
