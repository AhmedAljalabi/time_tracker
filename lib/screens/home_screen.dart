import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_task_provider.dart';
import '../screens/AddTimeEntryScreen.dart';

import 'package:time_tracker/models/TimeEntry.dart';

import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Time Tracking"),
        backgroundColor: const Color.fromARGB(255, 47, 143, 122),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "All Entries"),
            Tab(text: "Grouped by Projects"),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 54, 161, 138),
              ),
              child: Align(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.folder, color: Colors.black),
              title: const Text('Projects'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_projects');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment, color: Colors.black),
              title: const Text('Tasks'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_tasks');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildTimeEntryAllEntries(context),
          buildTimeEntryGroupedByProjects(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddTimeEntryScreen())),
        tooltip: 'Add TmeEntry',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildTimeEntryAllEntries(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_empty,
                color: Colors.grey[500],
                size: 80,
              ),
              const Text("   "),
              Text(
                "No time entries yet!",
                style: TextStyle(color: Colors.grey[600], fontSize: 25),
              ),
              Text(
                "  Tap the + button to add your first entry",
                style: TextStyle(color: Colors.grey[400], fontSize: 18),
              )
            ],
          );
        }
        return ListView.builder(
          itemCount: provider.entries.length,
          itemBuilder: (context, index) {
          final project = provider.projects[index];
          final entry = provider.entries[index];
          final task = provider.tasks[index];

            String formattedDate =
                DateFormat('MMM dd, yyyy').format(entry.date);
            return Dismissible(
              key: Key(entry.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                provider.removeTimeEntry(entry.id);
              },
              background: Container(
                color: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                color: Colors.purple[50],
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
         child: ListTile(
          title: Text("${project.name} - ${task.name}"),
         subtitle: Text("Total Time: ${entry.totalTime} \n Date: $formattedDate \n Note:${entry.notes}"),
                  isThreeLine: true,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTimeEntryGroupedByProjects(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [

            Icon(Icons.hourglass_empty,color: Colors.grey[500],size: 80, ),
            const Text("   "),
            Text(
              "No time entries yet!",
              style: TextStyle(color: Colors.grey[600], fontSize: 25),
            ),
            Text(
              "  Tap the + button to add your first entry",
              style: TextStyle(color: Colors.grey[400], fontSize: 18),
            )


          ],

        );
        }

        // Grouping TimeEntry by Project
        var grouped = groupBy(provider.entries, (TimeEntry e) => e.projectId);
        return ListView(
          children: grouped.entries.map((entry) {
            String projectName = getProjectNameById(
            
                context, entry.key); // Ensure you implement this function
              
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "$projectName",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 54, 161, 138),
                    ),
                  ),
                ),
                ListView.builder(
                  physics:
                      const NeverScrollableScrollPhysics(), // to disable scrolling within the inner list view
                  shrinkWrap:
                      true, // necessary to integrate a ListView within another ListView
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    TimeEntry entries = entry.value[index];

                    return ListTile(


                      
                     
                      title: Text(
                          "- Task${entries.taskId}: ${entries.totalTime} hours on { ${entries.date.day} ${entries.date.month},${entries.date.year}}"),
                     
                    );
                  },
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  // home_screen.dart
  String getProjectNameById(BuildContext context, String projectId) {
    var project = Provider.of<TimeEntryProvider>(context, listen: false)
        .projects
        .firstWhere((cat) => cat.id == projectId);
    return project.name;
  }


}
