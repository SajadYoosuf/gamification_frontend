import 'dart:convert';

class Course {
  String id;
  String courseName;
  String discription;
  String duration;
  String fee;
  DateTime startDate;
  DateTime endDate;
  String assignedMentor;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Course({
    required this.id,
    required this.courseName,
    required this.discription,
    required this.duration,
    required this.fee,
    required this.startDate,
    required this.endDate,
    required this.assignedMentor,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Course.fromRawJson(String str) => Course.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["_id"],
    courseName: json["CourseName"],
    discription: json["Discription"],
    duration: json["Duration"],
    fee: json["Fee"],
    startDate: DateTime.parse(json["StartDate"]),
    endDate: DateTime.parse(json["EndDate"]),
    assignedMentor: json["AssignedMentor"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "CourseName": courseName,
    "Discription": discription,
    "Duration": duration,
    "Fee": fee,
    "StartDate": startDate.toIso8601String(),
    "EndDate": endDate.toIso8601String(),
    "AssignedMentor": assignedMentor,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
