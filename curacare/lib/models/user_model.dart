class UserModel {
  final String id;
  final String username;
  final List<String> medicines;
  final List<String> conditions;
  UserModel({
    required this.id,
    required this.username,
    required this.medicines,
    required this.conditions,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      medicines: List<String>.from(json['medicines']),
      conditions: List<String>.from(json['conditions']),
    );
  }
}
