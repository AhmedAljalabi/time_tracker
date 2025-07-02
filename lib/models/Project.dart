
class Project {
  final String id;
  final String name;
  final bool isDefault; // To identify if it's a system default or user-added

 Project({
    required this.id,
    required this.name,
    this.isDefault = false,
  });
}
