import 'package:flutter/material.dart';
import 'package:novox_edtech_gamification/screens/admin/employee_management_screen.dart';
import 'package:novox_edtech_gamification/screens/admin/student_management.dart';
import 'package:novox_edtech_gamification/screens/admin/attendance_management.dart';
import 'package:novox_edtech_gamification/screens/admin/course_management.dart';
import 'package:novox_edtech_gamification/utils/image_paths.dart';
import 'package:provider/provider.dart';
import 'package:novox_edtech_gamification/model/role_wise_dashboard_rootes.dart';
import 'package:novox_edtech_gamification/model/user_roles.dart';
import 'package:novox_edtech_gamification/screens/admin/dashboard_screen.dart';
import 'package:novox_edtech_gamification/providers/login_provider.dart';

class RoleBasedDashboard extends StatefulWidget {
  const RoleBasedDashboard({super.key});

  @override
  State<RoleBasedDashboard> createState() => _RoleBasedDashboardState();
}

class _RoleBasedDashboardState extends State<RoleBasedDashboard> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _getPagesForRole(UserRoles role, String roleName) {
    switch (role) {
      case UserRoles.admin:
        return [
          DashboardScreen(role: roleName, screenTitle: 'Dashboard'),
          const StudentManagement(),
          const EmployeeManagement(),
          const AttendanceManagement(),
          const CourseManagement(),
        ];
      case UserRoles.student:
        return [
          DashboardScreen(role: roleName, screenTitle: 'Dashboard'),
          DashboardScreen(role: roleName, screenTitle: 'Checkin & Checkout'),
        ];
      case UserRoles.employee:
        return [
          DashboardScreen(role: roleName, screenTitle: 'Dashboard'),
          DashboardScreen(role: roleName, screenTitle: 'Checkin & Checkout'),
        ];
      case UserRoles.none:
        return [];
    }
  }

  Widget _buildDrawer(List<NavDestination> destinations, List<Widget> pages,
      {bool isOverlay = true}) {
    final content = Column(
      children: [
        // Header section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          color: Colors.white,
          child: SafeArea(
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF4FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Image.asset(
                    ImagePaths.companyLogo,
                    width: 26,
                    height: 26,
                  )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Novox',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50))),
                      SizedBox(height: 2),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    Provider.of<LoginProvider>(context, listen: false)
                        .userRoles
                        .toString()
                        .split('.')
                        .last
                        .toUpperCase(),
                    style: const TextStyle(
                        color: Color(0xFF7F8C8D),
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Navigation items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];
              final isSelected = _selectedIndex == index;
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: Material(
                  color: isSelected
                      ? const Color(0xFF4A90E2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() => _selectedIndex = index);
                      if (isOverlay) Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? destination.selectedIcon
                                : destination.icon,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF7F8C8D),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              destination.label,
                              style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF2C3E50),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal),
                            ),
                          ),
                          if (isSelected)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Color(0xFFEF5350)),
          title: const Text('Logout',
              style: TextStyle(
                  color: Color(0xFFEF5350), fontWeight: FontWeight.w600)),
          onTap: () {
            if (isOverlay) Navigator.pop(context);
            Provider.of<LoginProvider>(context, listen: false).logOut(context);
          },
        ),
        const SizedBox(height: 8),
      ],
    );

    if (isOverlay) return Drawer(child: content);
    return Container(
      width: 260,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final isTablet = screenWidth > 600 && screenWidth <= 1024;
    final isDesktop = screenWidth > 1024;

    final loginProvider = Provider.of<LoginProvider>(context);
    final currentUserRoles = loginProvider.userRoles;

    List<NavDestination> currentDestinations;
    String roleName;

    switch (currentUserRoles) {
      case UserRoles.admin:
        currentDestinations = DashboardRoutes.admin;
        roleName = 'Admin';
        break;
      case UserRoles.student:
        currentDestinations = DashboardRoutes.student;
        roleName = 'Student';
        break;
      case UserRoles.employee:
        currentDestinations = DashboardRoutes.employee;
        roleName = 'Employee';
        break;
      case UserRoles.none:
        throw UnimplementedError();
    }

    final List<Widget> _pages = _getPagesForRole(currentUserRoles, roleName);
    if (_selectedIndex >= _pages.length) _selectedIndex = 0;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: (isMobile || isTablet)
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : null,
        title: Image.asset(
          ImagePaths.companyLogoWithText,
          fit: BoxFit.fitWidth,
          width: 100.0,
          height: 60.0,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () =>
                Provider.of<LoginProvider>(context, listen: false)
                    .logOut(context),
          ),
          const SizedBox(width: 20),
        ],
      ),
      drawer:
          (isMobile || isTablet) ? _buildDrawer(currentDestinations, _pages) : null,
      body: Row(
        children: [
          if (isDesktop)
            _buildDrawer(currentDestinations, _pages, isOverlay: false),
          if (isDesktop) const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _pages.isEmpty
                ? const Center(child: Text('No view to display.'))
                : _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
