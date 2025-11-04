import 'dart:convert';

class StudentModal {
    bool status;
    List<Datum> data;

    StudentModal({
        required this.status,
        required this.data,
    });

    factory StudentModal.fromRawJson(String str) => StudentModal.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory StudentModal.fromJson(Map<String, dynamic> json) => StudentModal(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String id;
    String fullname;
    String guardian;
    String address;
    String contactNumber;
    String guardianNumber;
    String dob;
    String aadhar;
    String pan;
    String bloodGroup;
    DateTime joiningDate;
    String email;
    String course;
    String emergencyContactName;
    String emergencyNumber;
    String relationship;
    DateTime createdAt;
    DateTime updatedAt;
    int v;
    List<dynamic>? fee;

    Datum({
        required this.id,
        required this.fullname,
        required this.guardian,
        required this.address,
        required this.contactNumber,
        required this.guardianNumber,
        required this.dob,
        required this.aadhar,
        required this.pan,
        required this.bloodGroup,
        required this.joiningDate,
        required this.email,
        required this.course,
        required this.emergencyContactName,
        required this.emergencyNumber,
        required this.relationship,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        this.fee,
    });

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        fullname: json["Fullname"],
        guardian: json["Guardian"],
        address: json["Address"],
        contactNumber: json["ContactNumber"],
        guardianNumber: json["GuardianNumber"],
        dob: json["DOB"],
        aadhar: json["Aadhar"],
        pan: json["PAN"],
        bloodGroup: json["BloodGroup"],
        joiningDate: DateTime.parse(json["JoiningDate"]),
        email: json["Email"],
        course: json["Course"],
        emergencyContactName: json["EmergencyContactName"],
        emergencyNumber: json["EmergencyNumber"],
        relationship: json["Relationship"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        fee: json["fee"] == null ? [] : List<dynamic>.from(json["fee"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "Fullname": fullname,
        "Guardian": guardian,
        "Address": address,
        "ContactNumber": contactNumber,
        "GuardianNumber": guardianNumber,
        "DOB": dob,
        "Aadhar": aadhar,
        "PAN": pan,
        "BloodGroup": bloodGroup,
        "JoiningDate": joiningDate.toIso8601String(),
        "Email": email,
        "Course": course,
        "EmergencyContactName": emergencyContactName,
        "EmergencyNumber": emergencyNumber,
        "Relationship": relationship,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "fee": fee == null ? [] : List<dynamic>.from(fee!.map((x) => x)),
    };
}

/// Lightweight UI model used by student list widget (keeps UI separate from API model)
class StudentModel {
    final String id;
    final String? name;
    final String course;
    final String duration;
    final int progress;
    final String feeStatus;
    final String lastLogin;
    final String? imageUrl;

    StudentModel({
        required this.id,
        required this.name,
        required this.course,
        required this.duration,
        required this.progress,
        required this.feeStatus,
        required this.lastLogin,
        this.imageUrl,
    });
}
