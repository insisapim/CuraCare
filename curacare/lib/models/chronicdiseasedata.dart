class Chronicdiseasedata {
  final int id;
  final String name;
  final String detail;
  final String description;
  final String treatment;

  Chronicdiseasedata({
    required this.id,
    required this.name,
    required this.detail,
    required this.description,
    required this.treatment,
  });
  factory Chronicdiseasedata.fromJson(Map<String, dynamic> json) {
    return Chronicdiseasedata(
      id: json['id'],
      name: json['name'],
      detail: json['detail'],
      description: json['description'],
      treatment: json['treatment'],
    );
  }
}
