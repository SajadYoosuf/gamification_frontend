import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:novox_edtech_gamification/providers/student_checkin_provider.dart';

class StudentCheckinCheckout extends StatefulWidget {
  const StudentCheckinCheckout({Key? key}) : super(key: key);

  @override
  State<StudentCheckinCheckout> createState() => _StudentCheckinCheckoutState();
}

class _StudentCheckinCheckoutState extends State<StudentCheckinCheckout> {
  String? _currentUserId;
  // leave fields removed — checkin/checkout only

  // local timeline removed: timeline will be built from provider.today

  // check toggle logic moved into StudentCheckinProvider (performCheckIn / performCheckOut)

  // leave date picker removed; check-in/out only

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('currentUserId');
      setState(() => _currentUserId = id);
      if (id != null) {
        final prov = Provider.of<StudentCheckinProvider>(context, listen: false);
        await prov.loadTodayAttendance(id);
      }
    });
  }

  // leave submit removed

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;
    final isLarge = width >= 1100; // laptop / large screens

    return Scaffold(
      backgroundColor: const Color(0xfff7f9fb),
      appBar: AppBar(
        title: const Text('Check-in / Check-out'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<StudentCheckinProvider>(
          builder: (context, prov, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Track your attendance and manage your daily schedule.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Large-screen: two-column full-width layout (no centered ConstrainedBox)
            if (isLarge) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _card(_buildCurrentStatusCard(prov)),
                        const SizedBox(height: 16),
                        _card(_buildTimelineCard(isLarge: true, prov: prov)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        // keep a smaller summary card area on right
                      ],
                    ),
                  ),
                ],
              ),
            ] else if (isTablet) ...[
              // Tablet: two-column but centered/wrap-friendly
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: _card(_buildCurrentStatusCard(prov))),
                  const SizedBox(width: 16),
                  Expanded(flex: 1, child: _card(_buildTimelineCard(prov: prov))),
                  const SizedBox(width: 16),
                ],
              ),
            ] else ...[
              // Mobile: stacked
              _card(_buildCurrentStatusCard(prov)),
              const SizedBox(height: 12),
              _card(_buildTimelineCard(prov: prov)),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
        ),
    );
  }

  // ----------------- Individual Cards -----------------

  Widget _card(Widget child, {double? width}) {
    return Container(
      width: width ?? double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }

  Widget _buildCurrentStatusCard([StudentCheckinProvider? prov]) {
    prov ??= Provider.of<StudentCheckinProvider>(context);
    final sa = prov.today;
    final checkedIn = prov.isCheckedIn;
    final hasCheckedOut = prov.hasCheckedOut;
    final loading = prov.loading || prov.actionLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Current Status', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hasCheckedOut ? 'Today Completed' : (checkedIn ? 'Checked In' : 'Checked Out'),
              style: TextStyle(color: hasCheckedOut ? Colors.blueGrey : (checkedIn ? Colors.green : Colors.grey), fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: CircleAvatar(
            radius: 36,
            backgroundColor: (checkedIn ? Colors.green : Colors.grey).withOpacity(0.12),
            child: Icon(checkedIn ? Icons.check : Icons.hourglass_empty, color: checkedIn ? Colors.green : Colors.grey, size: 34),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            // If the user has checked out, show checkout time; otherwise show checkin or not checked in
            hasCheckedOut
                ? 'You finished at ${DateFormat('h:mm a').format(sa!.checkout!.toLocal())}'
                : (sa?.checkin != null
                    ? 'You checked in at ${DateFormat('h:mm a').format(sa!.checkin!.toLocal())}'
                    : (prov.isLeaveApplied ? 'You applied for leave today' : 'You are not checked in yet')),
            style: const TextStyle(color: Colors.black54),
          ),
        ),
        const SizedBox(height: 12),
        // Only show the check-in/out button when the day is not finished and leave not applied
        if (!hasCheckedOut && !prov.isLeaveApplied)
          ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: checkedIn ? Colors.red : Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 12),
            minimumSize: const Size.fromHeight(45),
          ),
            onPressed: loading || _currentUserId == null
                ? null
                : () async {
                    if (checkedIn) {
                      // checkout flow with rating dialog
                      final result = await _showCheckoutDialog();
                      if (result != null && result['rating'] != null) {
                        await prov!.performCheckOut(_currentUserId!, rating: result['rating'] as int, review: result['review'] as String?);
                      }
                    } else {
                      // checkin
                      await prov!.performCheckIn(_currentUserId!);
                    }
                  },
          icon: Icon(checkedIn ? Icons.logout : Icons.login),
          label: Text(checkedIn ? 'Check Out' : 'Check In'),
          ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Time Today'),
              Text(
                sa?.checkin != null
                    ? (() {
                        final start = sa!.checkin!;
                        final end = sa.checkout ?? DateTime.now().toUtc();
                        final dur = end.toLocal().difference(start.toLocal());
                        return '${dur.inHours}h ${dur.inMinutes.remainder(60)}m';
                      })()
                    : '0h 0m',
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Attendance rewards removed per UX request (unused)

  Widget _buildTimelineCard({bool isLarge = false, StudentCheckinProvider? prov}) {
    final itemPadding = isLarge ? 16.0 : 12.0;
    final avatarRadius = isLarge ? 18.0 : 16.0;
    final iconSize = isLarge ? 18.0 : 16.0;
    final titleStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: isLarge ? 16 : 14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's Timeline", style: TextStyle(fontWeight: FontWeight.bold, fontSize: isLarge ? 18 : 15)),
        const SizedBox(height: 10),
        Column(
          children: (() {
            final List<_TimelineItem> items = [];
            final sa = prov?.today;
            if (sa?.checkin != null) {
              items.add(_TimelineItem('Checked In', sa!.checkin!.toLocal(), _TimelineStatus.checkedIn));
            }
            if (sa?.checkout != null) {
              items.add(_TimelineItem('Checked Out', sa!.checkout!.toLocal(), _TimelineStatus.checkedOut));
            }
            if (items.isEmpty) items.add(_TimelineItem('Pending Check Out', null, _TimelineStatus.pending));
            return items.map((t) {
            final color = t.status == _TimelineStatus.checkedIn
                ? Colors.green
                : t.status == _TimelineStatus.checkedOut
                    ? Colors.red
                    : Colors.grey;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(itemPadding),
                decoration: BoxDecoration(color: color.withOpacity(0.07), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    CircleAvatar(radius: avatarRadius, backgroundColor: color, child: Icon(t.icon, color: Colors.white, size: iconSize)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.title, style: titleStyle),
                          const SizedBox(height: 4),
                          Text(
                            t.time != null ? DateFormat('h:mm a').format(t.time!) : 'Currently active',
                            style: TextStyle(color: Colors.black54, fontSize: isLarge ? 14 : 13),
                          ),
                        ],
                      ),
                    ),
                    Icon(t.status == _TimelineStatus.pending ? Icons.more_horiz : Icons.check_circle, color: Colors.grey),
                  ],
                ),
              );
            }).toList();
          })(),
        ),
      ],
    );
  }

  Future<Map<String, Object?>?> _showCheckoutDialog() {
    int rating = 5;
    final TextEditingController reviewController = TextEditingController();

    return showDialog<Map<String, Object?>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout — Review your day'),
        content: StatefulBuilder(builder: (context, setState) {
          return SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Use a Wrap with compact tappable icons so the row can wrap on very narrow screens
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    runSpacing: 6,
                    children: List.generate(5, (i) {
                      final filled = i < rating;
                      return InkWell(
                        onTap: () => setState(() => rating = i + 1),
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            filled ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 28,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: reviewController,
                    maxLines: 3,
                    decoration: const InputDecoration(hintText: 'Leave a short review (optional)'),
                  ),
                ],
              ),
            ),
          );
        }),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(null), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop({'rating': rating, 'review': reviewController.text});
            },
            child: const Text('Submit & Checkout'),
          ),
        ],
      ),
    );
  }

}

// ----------------- Models -----------------

enum _TimelineStatus { checkedIn, checkedOut, pending }

class _TimelineItem {
  final String title;
  final DateTime? time;
  final _TimelineStatus status;

  _TimelineItem(this.title, this.time, this.status);

  IconData get icon {
    switch (status) {
      case _TimelineStatus.checkedIn:
        return Icons.login;
      case _TimelineStatus.checkedOut:
        return Icons.logout;
      default:
        return Icons.hourglass_empty;
    }
  }
}
