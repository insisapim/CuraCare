class AppointmentModel {
  final String id;
  final String uid;
  final String title;
  final String location;
  final DateTime dateTime;
  final String detail;

  AppointmentModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.location,
    required this.dateTime,
    required this.detail,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json["id"],
      uid: json["uid"],
      title: json["title"],
      location: json["location"],
      dateTime: json["dateTime"],
      detail: json["detail"],
    );
  }
}
