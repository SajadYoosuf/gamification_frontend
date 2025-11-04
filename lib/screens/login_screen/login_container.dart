import 'package:flutter/material.dart';
import 'package:novox_edtech_gamification/providers/login_provider.dart';
import 'package:provider/provider.dart';

import '../../model/user_roles.dart';
import '../../styles/login_page_text_styles.dart';
import 'login_screen_user_roles_widget.dart';

class LoginContainer extends StatelessWidget {
  const LoginContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final double screenWidth = screen.width;
    final double screenHeight = screen.height;
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final double fieldFont = isMobile ? 14 : 16;

    final double containerWidth = isMobile
        ? screenWidth * 0.9
        : isTablet
        ? screenWidth * 0.7
        : screenWidth * 0.5;
    return Consumer<LoginProvider>(
      builder: (context,loginProvider,child) {
        return Container(
          width: containerWidth,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(0.95),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Role",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: fieldFont,
                ),
              ),
              const SizedBox(height: 10),

              // Role Selection
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFBDBDBD).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    LoginScreenUserRolesWidget(
                      lablel: "Admin",
                      roleIcon: Icons.manage_accounts,
                      userRoles: UserRoles.admin,
                    ),
                    LoginScreenUserRolesWidget(
                      lablel: "Student",
                      roleIcon: Icons.school,
                      userRoles: UserRoles.student,
                    ),
                    LoginScreenUserRolesWidget(
                      lablel: "Employee",
                      roleIcon: Icons.engineering,
                      userRoles: UserRoles.employee,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Text("Email / Username",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fieldFont)),
              const SizedBox(height: 10),

              TextField(
                onChanged: (value) =>
                    loginProvider.loginModalUpdating(value, 1),
                decoration: InputDecoration(
                  errorText: loginProvider.emailError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: "Enter your email or username",
                  suffixIcon: const Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 15),

              Text("Password",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fieldFont)),
              const SizedBox(height: 10),

              TextField(
                obscureText: loginProvider.isCheckinForTheEye,
                onChanged: (value) =>
                    loginProvider.loginModalUpdating(value, 2),
                decoration: InputDecoration(
                  errorText: loginProvider.passwordError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: "Enter your password",
                  suffixIcon: IconButton(
                    onPressed: () => loginProvider.togglePasswordVisibility(
                    ),
                    icon: Icon(
                      loginProvider.isCheckinForTheEye
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Login Button
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child:ElevatedButton(
                    onPressed: loginProvider.isLoading
                        ? null
                        : () async {
                      if (loginProvider.validateForm()) {
                        final snackBar = await loginProvider.login(context);
                        if (snackBar != null ) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: LoginPageTextStyles.globalColor,
                    ),
                    child: loginProvider.isLoading
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.login, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )

              ),

              const SizedBox(height: 20),
              // Motivation Text
              Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF1FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    "Every login is a step in your Novox journey 🚀",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
