class Appointmentdata {
  final int id;
  final String title;
  final String location;
  final String startTime;
  final String endTime;
  final String detail;
  String? app_type;
  
  Appointmentdata({
    required this.id,
    required this.title,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.detail,
    this.app_type
  });

  factory Appointmentdata.fromJson(Map<String, dynamic> json){
    return Appointmentdata(
      id: json['id'],
      title: json['title'],
      location: json['location'],
      startTime: json['start_time'],
      endTime: json['end_time'], 
      detail: json['detail']
      );
  }
}