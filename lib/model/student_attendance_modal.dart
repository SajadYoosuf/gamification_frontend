import 'dart:convert';

class StudentAttendance {
  String id;
  String? userId;
  DateTime date;
  String status;
  DateTime? checkin;
  dynamic workingHours;
  int? v;
  DateTime? checkout;
  int? rating;
  String? review;
  String? fullname;

  StudentAttendance({
    required this.id,
    this.userId,
    required this.date,
    required this.status,
    this.checkin,
    this.workingHours,
    this.v,
    this.checkout,
    this.rating,
    this.review,
    this.fullname,
  });

  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    return StudentAttendance(
      id: json["_id"]?.toString() ?? "",

      /// ✅ userId can be string or object
      userId: json["userId"] is Map
          ? json["userId"]["_id"]?.toString()
          : json["userId"]?.toString(),

      /// ✅ date (2025-11-05)
      date: DateTime.tryParse(json["date"]?.toString() ?? "") ??
          DateTime.now(),

      /// ✅ status
      status: json["status"]?.toString() ?? "-",

      /// ✅ Checkin can be ISO string or null
      checkin:
          DateTime.tryParse(json["Checkin"]?.toString() ?? ""),

      /// ✅ Working hours may be null or number
      workingHours: json["WorkingHours"],

      /// ✅ Version
      v: json["__v"] is int
          ? json["__v"]
          : int.tryParse(json["__v"]?.toString() ?? ""),

      /// ✅ Checkout
      checkout:
          DateTime.tryParse(json["Checkout"]?.toString() ?? ""),

      /// ✅ rating
      rating: json["rating"] is int
          ? json["rating"]
          : int.tryParse(json["rating"]?.toString() ?? ""),

      /// ✅ review
      review: json["review"]?.toString(),

      /// ✅ Fullname from nested userId OR root
      fullname: json["Fullname"]?.toString() ??
          (json["userId"] is Map
              ? json["userId"]["Fullname"]?.toString()
              : null),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "status": status,
        "Checkin": checkin?.toIso8601String(),
        "WorkingHours": workingHours,
        "__v": v,
        "Checkout": checkout?.toIso8601String(),
        "rating": rating,
        "review": review,
        "Fullname": fullname,
      };
}
