import 'dart:convert';

class StudentAttendance {
    String id;
    String? userId; // may be null for some employee records
    DateTime date;
    String status;
    DateTime? checkin;
    dynamic workingHours;
    int? v;
    DateTime? checkout;
    int? rating;
    String? review;
    String? fullname; // some attendance docs store Fullname directly

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

    factory StudentAttendance.fromRawJson(String str) => StudentAttendance.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

        factory StudentAttendance.fromJson(Map<String, dynamic> json) {
                // parse with tolerance for missing/null fields and different key casings
                DateTime parsedDate = DateTime.tryParse(json["date"]?.toString() ?? '') ?? DateTime.now();

                DateTime? parsedCheckin;
                try {
                    final s = json['Checkin'] ?? json['checkin'];
                    if (s != null) parsedCheckin = DateTime.tryParse(s.toString());
                } catch (_) {
                    parsedCheckin = null;
                }

                DateTime? parsedCheckout;
                try {
                    final s = json['Checkout'] ?? json['checkout'];
                    if (s != null) parsedCheckout = DateTime.tryParse(s.toString());
                } catch (_) {
                    parsedCheckout = null;
                }

                return StudentAttendance(
                        id: json["_id"]?.toString() ?? '',
                        userId: json["userId"]?.toString(),
                        date: parsedDate,
                        status: json["status"]?.toString() ?? '-',
                        checkin: parsedCheckin,
                        workingHours: json["WorkingHours"],
                        v: json["__v"] is int ? json["__v"] as int : int.tryParse(json["__v"]?.toString() ?? ''),
                        checkout: parsedCheckout,
                        rating: json["rating"] is int ? json["rating"] as int : int.tryParse(json["rating"]?.toString() ?? ''),
                        review: json["review"]?.toString(),
                        fullname: json['Fullname']?.toString() ?? json['fullname']?.toString(),
                );
        }

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
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
