import 'dart:convert';


UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel  {
  String name;
  String job;
  String id;
  DateTime created_at;

  UserModel({
    required this.name,
    required this.job,
    required this.id,
    required this.created_at,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json["name"],
    job: json["job"],
    id: json["id"],
    created_at: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "job": job,
    "id": id,
    "createdAt": created_at.toIso8601String(),
  };
}