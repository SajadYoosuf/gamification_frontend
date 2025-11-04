class EmployeeModal {
  final String id;
  final String fullname;
  final String address;
  final String contactNumber;
  final String aadharNumber;
  final String pan;
  final String joiningDate;
  final String blood;
  final List<String> designation;
  final String courseAssigned;
  final String email;
  final String password;
  final String emergencyContactName;
  final String emergencyNumber;
  final String relationship;
  final List<dynamic> salary;
  final String createdAt;
  final String updatedAt;

  EmployeeModal({
    required this.id,
    required this.fullname,
    required this.address,
    required this.contactNumber,
    required this.aadharNumber,
    required this.pan,
    required this.joiningDate,
    required this.blood,
    required this.designation,
    required this.courseAssigned,
    required this.email,
    required this.password,
    required this.emergencyContactName,
    required this.emergencyNumber,
    required this.relationship,
    required this.salary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmployeeModal.fromJson(Map<String, dynamic> json) {
    return EmployeeModal(
      id: json['_id'] ?? '',
      fullname: json['Fullname'] ?? '',
      address: json['Address'] ?? '',
      contactNumber: json['ContactNumber'] ?? '',
      aadharNumber: json['AadharNumber'] ?? '',
      pan: json['PAN'] ?? '',
      joiningDate: json['JoiningDate'] ?? '',
      blood: json['Blood'] ?? '',
      designation: List<String>.from(json['Designation'] ?? []),
      courseAssigned: json['CourseAssained'] ?? '',
      email: json['Email'] ?? '',
      password: json['Password'] ?? '',
      emergencyContactName: json['EmergencyContactName'] ?? '',
      emergencyNumber: json['EmergencyNumber'] ?? '',
      relationship: json['Relationship'] ?? '',
      salary: json['salary'] ?? [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
    "_id": id,
    "Fullname": fullname,
    "Address": address,
    "ContactNumber": contactNumber,
    "AadharNumber": aadharNumber,
    "PAN": pan,
    "JoiningDate": joiningDate,
    "Blood": blood,
    "Designation": List<dynamic>.from(designation.map((x) => x)),
    "CourseAssained": courseAssigned,
    "Email": email,
    "Password": password,
    "EmergencyContactName": emergencyContactName,
    "EmergencyNumber": emergencyNumber,
    "Relationship": relationship,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "salary": List<dynamic>.from(salary.map((x) => x)),
  };
}
