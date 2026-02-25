class AppointmentTypeData {
  final int id;
  final String name;
  
  AppointmentTypeData({
    required this.id,
    required this.name,
    
  });

  factory AppointmentTypeData.fromJson(Map<String, dynamic> json){
    return AppointmentTypeData(
      id: json['id'],
      name: json['name'], 
      );
  }
}