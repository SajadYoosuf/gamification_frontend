import 'package:intl/intl.dart';
import 'package:novox_edtech_gamification/model/student_attendance_modal.dart';
import 'package:novox_edtech_gamification/model/employee_attendance_modal.dart';

enum AttendanceType { student, employee }

class AttendanceModel {
  final String id;
  final String name;
  final String courseOrDepartment;
  final DateTime date;
  final String? checkInTime; // formatted as hh:mm a
  final String? checkOutTime; // formatted as hh:mm a
  final String totalHours;
  final String status;
  final AttendanceType type;
  final String? imageUrl;
  final int? rating;
  final String? review;

  // Employee-specific optional fields
  final String? breakIn;
  final String? breakOut;
  final String? leaveType;
  final String? reason;

  AttendanceModel({
    required this.id,
    required this.name,
    required this.courseOrDepartment,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    required this.totalHours,
    required this.status,
    required this.type,
    this.imageUrl,
    this.rating,
    this.review,
    this.breakIn,
    this.breakOut,
    this.leaveType,
    this.reason,
  });

  /// Build from StudentAttendance (tolerant to nulls)
  factory AttendanceModel.fromStudentAttendance(StudentAttendance s) {
    final timeFormat = DateFormat('hh:mm a');
    String? checkIn;
    String? checkOut;
    try {
      if (s.checkin != null) checkIn = timeFormat.format(s.checkin!);
    } catch (_) {
      checkIn = null;
    }
    try {
      if (s.checkout != null) checkOut = timeFormat.format(s.checkout!);
    } catch (_) {
      checkOut = null;
    }

    return AttendanceModel(
      id: s.id,
      name: s.fullname ?? s.userId ?? 'Unknown',
      courseOrDepartment: '-',
      date: s.date,
      checkInTime: checkIn,
      checkOutTime: checkOut,
      totalHours: s.workingHours?.toString() ?? '-',
      status: s.status,
      type: AttendanceType.student,
      imageUrl: null,
      rating: s.rating,
      review: s.review,
    );
  }

  /// Build from EmployeeAttendance
  factory AttendanceModel.fromEmployeeAttendance(EmployeeAttendance e) {
    final timeFormat = DateFormat('hh:mm a');
    String? checkIn;
    String? checkOut;
    try {
      checkIn = timeFormat.format(e.checkin);
    } catch (_) {
      checkIn = null;
    }
    try {
      checkOut = timeFormat.format(e.checkout);
    } catch (_) {
      checkOut = null;
    }

    return AttendanceModel(
      id: e.id,
      name: e.userId?.toString() ?? 'Unknown',
      courseOrDepartment: '-',
      date: e.date,
      checkInTime: checkIn,
      checkOutTime: checkOut,
      totalHours: e.workingHours?.toString() ?? '-',
      status: e.status,
      type: AttendanceType.employee,
      imageUrl: null,
    );
  }

  /// Generic fromJson helper when receiving mixed payloads
  factory AttendanceModel.fromJson(Map<String, dynamic> json, AttendanceType type) {
    DateTime parsedDate = DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now();
    String? checkIn;
    String? checkOut;
    try {
      if (json['Checkin'] != null) {
        final dt = DateTime.tryParse(json['Checkin'].toString());
        if (dt != null) checkIn = DateFormat('hh:mm a').format(dt);
      }
    } catch (_) {
      checkIn = json['Checkin']?.toString();
    }
    try {
      if (json['Checkout'] != null) {
        final dt = DateTime.tryParse(json['Checkout'].toString());
        if (dt != null) checkOut = DateFormat('hh:mm a').format(dt);
      }
    } catch (_) {
      checkOut = json['Checkout']?.toString();
    }

    return AttendanceModel(
      id: json['_id']?.toString() ?? '',
      name: json['Fullname']?.toString() ?? json['name']?.toString() ?? json['userId']?.toString() ?? 'Unknown',
      courseOrDepartment: json['course']?.toString() ?? json['department']?.toString() ?? '-',
      date: parsedDate,
      checkInTime: checkIn,
      checkOutTime: checkOut,
      totalHours: json['WorkingHours']?.toString() ?? '-',
      status: json['status']?.toString() ?? '-',
      type: type,
      imageUrl: json['imageUrl']?.toString(),
      rating: json['rating'] is int ? json['rating'] as int : int.tryParse(json['rating']?.toString() ?? ''),
      review: json['review']?.toString(),
      breakIn: json['Breakin']?.toString(),
      breakOut: json['Breakout']?.toString(),
      leaveType: json['Leavetype']?.toString(),
      reason: json['Reason']?.toString(),
    );
  }
}
