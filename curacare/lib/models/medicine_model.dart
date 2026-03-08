class MedicineModel {
  final String id;
  final String name;
  final String detail;
  

  MedicineModel({
    required this.id,
    required this.name,
    required this.detail,

  });
  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'],
      name: json['name'],
      detail: json['detail'],
    );
  }
}
