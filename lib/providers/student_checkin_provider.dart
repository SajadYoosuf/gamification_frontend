import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novox_edtech_gamification/model/student_attendance_modal.dart';
import 'package:novox_edtech_gamification/services/attendance_service.dart';

/// Provider to manage student check-in / check-out and leave state.
///
/// Responsibilities:
/// - Load today's attendance for the current user.
/// - Expose derived booleans: isCheckedIn, hasCheckedOut, isLeaveApplied.
/// - Perform check-in, check-out (with review/rating), and apply leave.
/// - Keep minimal loading/error state for UI wiring.
class StudentCheckinProvider extends ChangeNotifier {
  StudentAttendance? _today;
  bool _loading = false; // loading initial fetch
  bool _actionLoading = false; // loading for checkin/checkout/leave
  String? _error;

  StudentAttendance? get today => _today;
  bool get loading => _loading;
  bool get actionLoading => _actionLoading;
  String? get error => _error;

  // Derived helpers
  bool get isCheckedIn => _today?.checkin != null && _today?.checkout == null;
  bool get hasCheckedOut => _today?.checkout != null;
  bool get isLeaveApplied => (_today?.status.toLowerCase() ?? '') == 'leave';

  /// Load today's attendance for a user id (uses AttendanceService.getTodayAttendanceForUser)
  Future<void> loadTodayAttendance(String userId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final sa = await AttendanceService.getTodayAttendanceForUser(userId);
      // Ensure the returned attendance is for today's date (server may return nearby dates)
      if (sa != null) {
        final entryDate = sa.date.toLocal();
        final now = DateTime.now().toLocal();
        if (entryDate.year == now.year && entryDate.month == now.month && entryDate.day == now.day) {
          _today = sa;
        } else {
          // Not today's record - ignore
          _today = null;
          print('AttendanceProvider: fetched attendance is not for today (entry: ${entryDate.toIso8601String()})');
        }
      } else {
        _today = null;
      }
      print('Loaded today attendance: $_today');
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Perform check-in for the user. Posts current UTC time as Checkin and reloads today's entry.
 Future<void> performCheckIn(String userId) async {
  _actionLoading = true;
  _error = null;
  notifyListeners();
  try {
    final nowLocal = DateTime.now().toLocal();
    final payload = {
      'userId': userId,
      'date': DateFormat('yyyy-MM-dd').format(nowLocal),
      'Checkin': DateTime.now().toUtc().toIso8601String(), // ✅ fixed
    };
    await AttendanceService.postAttendanceForUser(userId, payload);
    await loadTodayAttendance(userId);
  } catch (e) {
    _error = e.toString();
    rethrow;
  } finally {
    _actionLoading = false;
    notifyListeners();
  }
}

Future<void> performCheckOut(String userId, {required int rating, String? review}) async {
  _actionLoading = true;
  _error = null;
  notifyListeners();
  try {
    final nowLocal = DateTime.now().toLocal();
    final payload = {
      'userId': userId,
      'date': DateFormat('yyyy-MM-dd').format(nowLocal),
      'Checkout': DateTime.now().toUtc().toIso8601String(),
      'rating': rating,
      if (review != null) 'review': review,
    };
    await AttendanceService.postAttendanceForUser(userId, payload);
    await loadTodayAttendance(userId);
  } catch (e) {
    _error = e.toString();
    rethrow;
  } finally {
    _actionLoading = false;
    notifyListeners();
  }
}


  /// Apply for leave. Posts leave and reloads today's entry.
  // Leave handling removed — this provider focuses on check-in / check-out only.
}
