class Medicine {
  final int id;
  final String name;
  final String dose;
  final String time;
  final String icon;

  Medicine({
    required this.id,
    required this.name,
    required this.dose,
    required this.time,
    required this.icon,
  });

  // Convert a Medicine object into a map object (for storing in the database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'time': time,
      'icon': icon,
    };
  }

  // Convert a map object into a Medicine object
  static Medicine fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      dose: map['dose'],
      time: map['time'],
      icon: map['icon'],
    );
  }
}
