import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';

/// A simple stateful student dashboard screen.
///
/// Behavior:
/// - Fetches students on first build via the provider
/// - Shows loading / error states
/// - Displays a refreshable list of student cards with basic info
class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  late StudentProvider _studentProv;

  @override
  void initState() {
    super.initState();
    // Defer provider calls until after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _studentProv = Provider.of<StudentProvider>(context, listen: false);
     
      // Also load the currently-logged-in student details (if any)
      _studentProv.fetchCurrentStudent();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: Consumer<StudentProvider>(
        builder: (context, prov, _) {
          if (prov.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
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
              // Welcome banner at top — show current student name when available
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                child: _buildWelcomeBanner(prov.currentStudent?.fullname ?? 'Student'),
              ),

              // Rest of the page: list with pull-to-refresh
              
            ],
          );
        },
      ),
    );
  }

  Widget _buildWelcomeBanner(String name) {
    // Example banner that matches the provided screenshot.
    // You can wire dynamic values into the stats if needed.
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
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4)),
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
                  children: [
                    Text(
                      // name is injected when available
                      'Welcome back, ${name.split(' ').isNotEmpty ? name.split(' ')[0] : name}! 👋',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Ready to continue your learning journey? You're doing great!",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              // decorative circle
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
          // Use a Wrap so cards will wrap on narrow screens instead of overflowing
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _statCard('Current Streak', '7 Days', Icons.local_fire_department, const Color(0xFF4FB6FF)),
              _statCard('Total XP', '1,250', Icons.star, const Color(0xFF8EE1FF)),
              _statCard('Rank', '#5', Icons.emoji_events, const Color(0xFF9DD9FF)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color bg) {
    return Container(
      constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}
