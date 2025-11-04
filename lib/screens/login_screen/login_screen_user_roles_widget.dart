import 'package:flutter/material.dart';
import 'package:novox_edtech_gamification/model/user_roles.dart';
import 'package:novox_edtech_gamification/providers/login_provider.dart';
import 'package:novox_edtech_gamification/styles/login_page_text_styles.dart';
import 'package:provider/provider.dart';

class LoginScreenUserRolesWidget extends StatelessWidget {
  final String lablel;
  final IconData roleIcon;
  final UserRoles userRoles;

  const LoginScreenUserRolesWidget({
    super.key,
    required this.lablel,
    required this.roleIcon,
    required this.userRoles,
  });

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();
    final isSelected = userRoles == loginProvider.userRoles;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => loginProvider.changeUserRole(userRoles),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: 100,
        height: 45,
        decoration: BoxDecoration(
          color: isSelected ? LoginPageTextStyles.globalColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(roleIcon, color: isSelected ? Colors.white : Colors.black),
            Flexible(
              child: Text(
                lablel,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
