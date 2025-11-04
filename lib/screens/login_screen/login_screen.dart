import 'package:flutter/material.dart';
import 'package:novox_edtech_gamification/model/user_roles.dart';
import 'package:novox_edtech_gamification/providers/login_provider.dart';
import 'package:novox_edtech_gamification/screens/login_screen/login_screen_user_roles_widget.dart';
import 'package:novox_edtech_gamification/styles/login_page_text_styles.dart';
import 'package:novox_edtech_gamification/utils/image_paths.dart';
import 'package:provider/provider.dart';

import 'login_container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final double screenWidth = screen.width;
    final double screenHeight = screen.height;

    // Responsive breakpoints using only MediaQuery
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final double containerWidth = isMobile
        ? screenWidth * 0.9
        : isTablet
        ? screenWidth * 0.7
        : screenWidth * 0.5;

    final double titleFont = isMobile ? 22 : 30;
    final double subtitleFont = isMobile ? 16 : 20;
    final double fieldFont = isMobile ? 14 : 16;

    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        return Scaffold(
          body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagePaths.loginScreenBackgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        width: isMobile ? 80 : 100,
                        height: isMobile ? 80 : 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: LoginPageTextStyles.globalColor,
                        ),
                        child: Center(
                          child: Image.asset(
                            ImagePaths.companyLogo,
                            color: Colors.white,
                            fit: BoxFit.contain,
                            width: isMobile ? 40 : 50,
                            height: isMobile ? 40 : 50,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Welcome To NovoxEdtech",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleFont,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      Text(
                        "Login to start your Novox journey",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: subtitleFont,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 25),
                      LoginContainer(),

                      // Login Card

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
