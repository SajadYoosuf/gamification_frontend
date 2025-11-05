import 'package:flutter/material.dart';
import 'package:novox_edtech_gamification/model/login_modal.dart';
import 'package:novox_edtech_gamification/model/user_roles.dart';
import 'package:novox_edtech_gamification/services/login_services.dart';
import 'package:novox_edtech_gamification/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class LoginProvider extends ChangeNotifier {
  UserRoles userRoles = UserRoles.none; // initially none
  LoginModal loginModal = LoginModal();
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  bool get isLoading => _isLoading;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  bool isCheckinForTheEye = false;

  LoginProvider() {
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    print("jdskfjdslkfj");
    final prefs = await SharedPreferences.getInstance();
    final savedRole = prefs.getString(AppConstant.authKeyForLocalStorage);
    print(savedRole);
    if (savedRole != null && savedRole != UserRoles.none.toString()) {
      userRoles = UserRoles.values.firstWhere(
            (role) => role.toString() == savedRole,
        orElse: () => UserRoles.none,
      );
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  void loginModalUpdating(String value, int index) {
    switch (index) {
      case 1:
        loginModal.Email = value;
        break;
      case 2:
        loginModal.Password = value;
        break;
    }
    notifyListeners();
  }

  void togglePasswordVisibility() {
    isCheckinForTheEye = !isCheckinForTheEye;
    notifyListeners();
  }

  void setEmail(String value) {
    loginModal.Email = value.trim();
    _emailError = _validateEmail(loginModal.Email ?? "");
    notifyListeners();
  }

  void setPassword(String value) {
    loginModal.Password = value.trim();
    _passwordError = _validatePassword(loginModal.Password ?? "");
    notifyListeners();
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'Email cannot be empty';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'Password cannot be empty';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  bool validateForm() {
    _emailError = _validateEmail(loginModal.Email ?? "");
    _passwordError = _validatePassword(loginModal.Password ?? "");
    notifyListeners();
    return _emailError == null && _passwordError == null;
  }

  void changeUserRole(UserRoles userRole) {
    userRoles = userRole;
    notifyListeners();
  }

  Future<SnackBar?> login(BuildContext context) async {
    if (!validateForm()) return null;
    _setLoading(true);
    try {
      Map<String, dynamic> response;
      switch (userRoles) {
        case UserRoles.admin:
          response = await LoginService.adminLogin(loginModal.toJson());
          break;
        case UserRoles.employee:
          response = await LoginService.employeeLogin(loginModal.toJson());
          break;
        case UserRoles.student:
          response = await LoginService.studentLogin(loginModal.toJson());
          break;
        case UserRoles.none:
          throw UnimplementedError();
      }
      _setLoading(false);

      final message = response['message'] ?? "Login response received";
      if (message.toLowerCase().contains("login successful")) {
        final prefs = await SharedPreferences.getInstance();
        // store role so the app can restore it on restart
        await prefs.setString(AppConstant.authKeyForLocalStorage, userRoles.toString());

        // If the server returned a data object with id, persist it as currentUserId
        try {
          final data = response['data'];
          if (data != null && data is Map<String, dynamic>) {
            final id = data['id'] ?? data['_id'] ?? data['Id'] ?? '';
            if (id != null && id.toString().isNotEmpty) {
              await prefs.setString('currentUserId', id.toString());
            }
          }
        } catch (_) {
          // ignore parsing errors; not critical
        }

        _isLoggedIn = true;
        notifyListeners();
        await Future.delayed(Duration(seconds: 2));
        GoRouter.of(context).go('/dashboard');
      }
      return SnackBar(content: Text(message));
    } catch (e) {
      _setLoading(false);
      notifyListeners();
      return SnackBar(content: Text("An error occurred during login."));
    }
  }

  void logOut(BuildContext context) async {
    userRoles = UserRoles.none;
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstant.authKeyForLocalStorage);
    notifyListeners();
    GoRouter.of(context).go('/');
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
