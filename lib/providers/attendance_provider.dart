import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:novox_edtech_gamification/model/attendance_model.dart';
import 'package:novox_edtech_gamification/services/attendance_service.dart';
import 'package:novox_edtech_gamification/services/student_service.dart';
import 'package:novox_edtech_gamification/services/employee_service.dart';

class AttendanceProvider extends ChangeNotifier {
  bool _loading = false;
  String? _error;
  List<AttendanceModel> _studentAttendance = [];
  List<AttendanceModel> _employeeAttendance = [];

  bool get loading => _loading;
  String? get error => _error;
  List<AttendanceModel> get studentAttendance => _studentAttendance;
  List<AttendanceModel> get employeeAttendance => _employeeAttendance;

  Future<void> fetchStudentAttendance() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch raw attendance entries from service
      final raw = await AttendanceService.fetchStudentAttendanceRaw();

      // Fetch students to resolve names (ID -> Fullname)
      Map<String, String> idToName = {};
      try {
        final studentsResp = await StudentService.getAllStudents();
        final decoded = studentsResp is String ? json.decode(studentsResp) : studentsResp;
        final List students = decoded is Map && decoded['data'] is List ? decoded['data'] : decoded;
        for (final s in students) {
          try {
            final map = Map<String, dynamic>.from(s);
            final id = map['_id']?.toString();
            final name = map['Fullname']?.toString() ?? map['fullname']?.toString();
            if (id != null && name != null) idToName[id] = name;
          } catch (_) {
            continue;
          }
        }
      } catch (_) {
        // ignore; we'll fallback to userId
      }

      final timeFormat = DateFormat('hh:mm a');
      final List<AttendanceModel> mapped = [];
      for (final attendance in raw) {
        try {
          final String name = (attendance.userId != null && idToName.containsKey(attendance.userId))
              ? (idToName[attendance.userId] ?? 'Unknown')
              : (attendance.fullname ?? attendance.userId ?? 'Unknown');
          String? checkIn;
          String? checkOut;
          if (attendance.checkin != null) {
            try {
              checkIn = timeFormat.format(attendance.checkin!);
            } catch (_) {
              checkIn = null;
            }
          }
          if (attendance.checkout != null) {
            try {
              checkOut = timeFormat.format(attendance.checkout!);
            } catch (_) {
              checkOut = null;
            }
          }

          mapped.add(AttendanceModel(
            id: attendance.id,
            name: name,
            courseOrDepartment: '-',
            date: attendance.date,
            checkInTime: checkIn,
            checkOutTime: checkOut,
            totalHours: attendance.workingHours?.toString() ?? '-',
            status: attendance.status,
            type: AttendanceType.student,
            imageUrl: null,
            rating: attendance.rating,
            review: attendance.review,
          ));
        } catch (_) {
          continue;
        }
      }

      // Initially show only today's records (filter by date equality)
      final today = DateTime.now();
      _studentAttendance = mapped.where((m) {
        final d = m.date;
        return d.year == today.year && d.month == today.month && d.day == today.day;
      }).toList();
    } catch (e) {
      _error = e.toString();
      _studentAttendance = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Fetches employee attendance (raw fetch from service + business mapping)
  Future<void> fetchEmployeeAttendance() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final raw = await AttendanceService.fetchEmployeeAttendanceRaw();

      // Fetch employees to resolve names (ID -> Fullname)
      Map<String, String> idToName = {};
      try {
        final employeesResp = await EmployeeService.getAllEmployees();
        final decoded = employeesResp is String ? json.decode(employeesResp) : employeesResp;
        final List employees = decoded is Map && decoded['data'] is List ? decoded['data'] : decoded;
        for (final s in employees) {
          try {
            final map = Map<String, dynamic>.from(s);
            final id = map['_id']?.toString();
            final name = map['Fullname']?.toString() ?? map['fullname']?.toString() ?? map['name']?.toString();
            if (id != null && name != null) idToName[id] = name;
          } catch (_) {
            continue;
          }
        }
      } catch (_) {
        // ignore; fallback to userId
      }

      final timeFormat = DateFormat('hh:mm a');
      final List<AttendanceModel> mapped = [];
      for (final attendance in raw) {
        try {
          final String name = (attendance.userId != null && idToName.containsKey(attendance.userId))
              ? (idToName[attendance.userId] ?? 'Unknown')
              : (attendance.fullname ?? attendance.userId ?? 'Unknown');
          String? checkIn;
          String? checkOut;
          if (attendance.checkin != null) {
            try {
              checkIn = timeFormat.format(attendance.checkin!);
            } catch (_) {
              checkIn = null;
            }
          }
          if (attendance.checkout != null) {
            try {
              checkOut = timeFormat.format(attendance.checkout!);
            } catch (_) {
              checkOut = null;
            }
          }

          mapped.add(AttendanceModel(
            id: attendance.id,
            name: name,
            courseOrDepartment: '-',
            date: attendance.date,
            checkInTime: checkIn,
            checkOutTime: checkOut,
            totalHours: attendance.workingHours?.toString() ?? '-',
            status: attendance.status,
            type: AttendanceType.employee,
            imageUrl: null,
            rating: attendance.rating,
            review: attendance.review,
          ));
        } catch (_) {
          continue;
        }
      }

      // Initially show only today's records (filter by date equality)
      final today = DateTime.now();
      _employeeAttendance = mapped.where((m) {
        final d = m.date;
        return d.year == today.year && d.month == today.month && d.day == today.day;
      }).toList();
    } catch (e) {
      _error = e.toString();
      _employeeAttendance = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
