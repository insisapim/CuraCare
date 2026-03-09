class MedicineModel {
  final String id;
  final String name;
  final String description;

  MedicineModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
    );
  }
}
