class Resident {
  final String id;
  final String name;

  Resident({required this.id, required this.name});

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
      id: json['id'].toString(),
      name: json['name'] ?? '',
    );
  }
}
