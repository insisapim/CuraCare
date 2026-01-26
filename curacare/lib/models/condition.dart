class Condition {
  final String id;
  final String name;
  final String? description;
  final String? detail;
  Condition({
    required this.id,
    required this.name,
    this.description,
    this.detail,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      id: json["id"] as String,
      name: json["name"] as String,
      description: json["description"] as String?,
      detail: json["detail"] as String?,
    );
  }
}
