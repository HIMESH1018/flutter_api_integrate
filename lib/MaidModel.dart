import 'dart:convert';


MaidModel mainModelFromJson(String str) => MaidModel.fromJson(json.decode(str));

String mainModelToJson(MaidModel data) => json.encode(data.toJson());

class MaidModel  {
  String name;
  String id;
  DateTime created_at;

  MaidModel({
    required this.name,
    required this.id,
    required this.created_at,
  });

  factory MaidModel.fromJson(Map<String, dynamic> json) => MaidModel(
    name: json["name"],
    id: json["id"],
    created_at: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "createdAt": created_at.toIso8601String(),
  };
}