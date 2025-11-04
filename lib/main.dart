import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:novox_edtech_gamification/providers/course_provider.dart';
import 'package:novox_edtech_gamification/providers/login_provider.dart';
import 'package:novox_edtech_gamification/utils/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:novox_edtech_gamification/providers/student_provider.dart';
import 'package:novox_edtech_gamification/providers/employee_provider.dart';
import 'package:novox_edtech_gamification/providers/attendance_provider.dart';
void main() {
  final loginProvider = LoginProvider();
  final appRouter = AppRouter(loginProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: loginProvider),
        ChangeNotifierProvider.value(value: CourseProvider()),
        ChangeNotifierProvider.value(value: EmployeeProvider()),
  ChangeNotifierProvider.value(value: StudentProvider()),
  ChangeNotifierProvider(create: (_) => AttendanceProvider()),



      ],
      child: MyApp(router: appRouter.router),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
