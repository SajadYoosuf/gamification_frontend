import 'dart:convert';

class EmployeeAttendance {
    String id;
    dynamic userId;
    DateTime date;
    String status;
    DateTime checkin;
    dynamic workingHours;
    int v;
    DateTime checkout;

    EmployeeAttendance({
        required this.id,
        required this.userId,
        required this.date,
        required this.status,
        required this.checkin,
        required this.workingHours,
        required this.v,
        required this.checkout,
    });

    factory EmployeeAttendance.fromRawJson(String str) => EmployeeAttendance.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory EmployeeAttendance.fromJson(Map<String, dynamic> json) => EmployeeAttendance(
        id: json["_id"],
        userId: json["userId"],
        date: DateTime.parse(json["date"]),
        status: json["status"],
        checkin: DateTime.parse(json["Checkin"]),
        workingHours: json["WorkingHours"],
        v: json["__v"],
        checkout: DateTime.parse(json["Checkout"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "status": status,
        "Checkin": checkin.toIso8601String(),
        "WorkingHours": workingHours,
        "__v": v,
        "Checkout": checkout.toIso8601String(),
    };
}
