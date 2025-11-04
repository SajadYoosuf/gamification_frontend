import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:novox_edtech_gamification/screens/login_screen/login_screen.dart';
import 'package:novox_edtech_gamification/screens/role_wise_dashboard.dart';
import 'package:novox_edtech_gamification/providers/login_provider.dart';

class AppRouter {
  final LoginProvider loginProvider;

  AppRouter(this.loginProvider);

  late final GoRouter router = GoRouter(
    refreshListenable: loginProvider,
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = loginProvider.isLoggedIn;
      final String location = state.uri.toString();

      // Redirect non-logged users to login unless already at '/'
      if (!isLoggedIn && location != '/') {
        return '/';
      }

      // Redirect logged-in users away from login page to dashboard
      if (isLoggedIn && location == '/') {
        return '/dashboard';
      }

      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const RoleBasedDashboard(),
      ),
    ],
  );
}
