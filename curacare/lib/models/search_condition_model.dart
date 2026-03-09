import 'dart:developer';

class SearchConditionModel {
  final String objectID;
  final String name;
  final String description;
  SearchConditionModel({
    required this.objectID,
    required this.name,
    required this.description,
  });

  factory SearchConditionModel.fromJson(Map<String, dynamic> json) {
    return SearchConditionModel(
      objectID: json["objectID"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
    );
  }
}
