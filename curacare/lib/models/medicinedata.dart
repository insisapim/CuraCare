class Medicinedata {
  final int id;
  final String name;
  final String detail;
  

  Medicinedata({
    required this.id,
    required this.name,
    required this.detail,

  });
  factory Medicinedata.fromJson(Map<String, dynamic> json) {
    return Medicinedata(
      id: json['id'],
      name: json['name'],
      detail: json['detail'],
    );
  }
}
