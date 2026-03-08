class ConditionModel {
  final String id;
  final String name;
  final String description;
  final String detail;
  final String imageUrl;
  ConditionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.detail,
    required this.imageUrl,
  });

  factory ConditionModel.fromJson(Map<String, dynamic> json) {
    return ConditionModel(
      id: json["id"] as String,
      name: json["name"] as String,
      description: json["description"] as String,
      detail: json["detail"] as String,
      imageUrl: json["imageUrl"] as String,
    );
  }
}
