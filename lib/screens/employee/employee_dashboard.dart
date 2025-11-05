import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/employee_provider.dart';

/// Employee dashboard screen mirroring the student dashboard UI/style.
/// - Fetches employees on first build via the provider
/// - Shows loading / error states
/// - Displays a refreshable list of employee cards with basic info
class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({Key? key}) : super(key: key);

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  late EmployeeProvider _empProv;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _empProv = Provider.of<EmployeeProvider>(context, listen: false);
      if (!_empProv.isLoading && _empProv.employees.isEmpty) {
        _empProv.fetchEmployees();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final isTablet = screenWidth > 600 && screenWidth <= 1024;
    return Scaffold(
      body: Consumer<EmployeeProvider>(
        builder: (context, prov, _) {
          if (prov.isLoading)
            return const Center(child: CircularProgressIndicator());
          if (prov.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  prov.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          return Column(
            children: [
                Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C3E50),
                ),
              ),
            ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12.0,
                ),
                child: _buildWelcomeBanner(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B7BE4), Color(0xFF1E6FD9)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Welcome back, Alex! 👋',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Here's your team's summary and quick actions.",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statCard('Active Today', '14', Icons.people, Color(0xFF4FB6FF)),
              const SizedBox(width: 12),
              _statCard(
                'Avg Hours',
                '6.4h',
                Icons.access_time,
                Color(0xFF8EE1FF),
              ),
              const SizedBox(width: 12),
              _statCard(
                'Open Leaves',
                '#2',
                Icons.beach_access,
                Color(0xFF9DD9FF),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bg.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
