import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Responsive Employee Check-in / Check-out screen
/// Mirrors the student screen but uses employee wording and can be wired
/// to an employee attendance provider later.
class EmployeeCheckinCheckout extends StatefulWidget {
  const EmployeeCheckinCheckout({Key? key}) : super(key: key);

  @override
  State<EmployeeCheckinCheckout> createState() => _EmployeeCheckinCheckoutState();
}

class _EmployeeCheckinCheckoutState extends State<EmployeeCheckinCheckout> {
  bool _checkedIn = false;
  DateTime? _lastCheckin;
  Duration _todayTotal = const Duration(hours: 3, minutes: 12);

  // Timeline sample items
  final List<_TimelineItem> _timeline = [
    _TimelineItem(title: 'Checked In', time: DateTime.now().subtract(const Duration(hours: 8)), status: _TimelineStatus.checkedIn),
    _TimelineItem(title: 'Checked Out', time: DateTime.now().subtract(const Duration(hours: 5, minutes: 10)), status: _TimelineStatus.checkedOut),
    _TimelineItem(title: 'Checked In', time: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)), status: _TimelineStatus.checkedIn),
    _TimelineItem(title: 'Pending Check Out', time: null, status: _TimelineStatus.pending),
  ];

  // Leave form state
  DateTime? _leaveDate;
  final TextEditingController _leaveReasonController = TextEditingController();
  bool _leavePending = false; // sample

  @override
  void dispose() {
    _leaveReasonController.dispose();
    super.dispose();
  }

  void _toggleCheck() {
    setState(() {
      if (_checkedIn) {
        // Check out
        _checkedIn = false;
        _timeline.insert(1, _TimelineItem(title: 'Checked Out', time: DateTime.now(), status: _TimelineStatus.checkedOut));
      } else {
        // Check in
        _checkedIn = true;
        _lastCheckin = DateTime.now();
        _timeline.insert(0, _TimelineItem(title: 'Checked In', time: _lastCheckin, status: _TimelineStatus.checkedIn));
      }
    });
  }

  Future<void> _pickLeaveDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(context: context, initialDate: now, firstDate: DateTime(now.year - 1), lastDate: DateTime(now.year + 2));
    if (picked != null) setState(() => _leaveDate = picked);
  }

  void _submitLeave() {
    // placeholder: set pending and clear
    setState(() {
      _leavePending = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Leave request submitted')));
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '--';
    return DateFormat('h:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    final spacing = isMobile ? 12.0 : 16.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Employee Check-in / Check-out')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Track your attendance and manage your daily schedule.', style: TextStyle(color: Colors.black54)),
            SizedBox(height: spacing),

            // Responsive grid: 1 column on mobile, 2 columns on tablet/desktop
            if (isMobile) ...[
              _buildCurrentStatusCard(),
              SizedBox(height: spacing),
              _buildAttendanceRewardsCard(),
              SizedBox(height: spacing),
              _buildTimelineCard(),
              SizedBox(height: spacing),
              _buildLeaveCard(),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCurrentStatusCard()),
                  SizedBox(width: spacing),
                  Expanded(child: _buildAttendanceRewardsCard()),
                ],
              ),
              SizedBox(height: spacing),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTimelineCard()),
                  SizedBox(width: spacing),
                  Expanded(child: _buildLeaveCard()),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCardShell({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
      child: child,
    );
  }

  Widget _buildCurrentStatusCard() {
    return _buildCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Current Status', style: TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              Row(children: [
                Icon(Icons.check_circle, color: _checkedIn ? Colors.green : Colors.grey, size: 14),
                const SizedBox(width: 6),
                Text(_checkedIn ? 'Checked In' : 'Checked Out', style: TextStyle(color: _checkedIn ? Colors.green : Colors.grey)),
              ]),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: CircleAvatar(radius: 36, backgroundColor: Colors.green.withOpacity(0.12), child: Icon(Icons.check, color: Colors.green, size: 30)),
          ),
          const SizedBox(height: 12),
          Center(child: Text(_lastCheckin != null ? 'You checked in at ${_formatTime(_lastCheckin)}' : 'You are not checked in yet', style: const TextStyle(color: Colors.black54))),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: _checkedIn ? Colors.red : Colors.blue, padding: const EdgeInsets.symmetric(vertical: 12)),
            onPressed: _toggleCheck,
            icon: Icon(_checkedIn ? Icons.logout : Icons.login),
            label: Text(_checkedIn ? 'Check Out' : 'Check In'),
          ),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(6)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total Time Today'), Text('${_todayTotal.inHours}h ${_todayTotal.inMinutes.remainder(60)}m', style: const TextStyle(color: Colors.blue))])),
        ],
      ),
    );
  }

  Widget _buildAttendanceRewardsCard() {
    return _buildCardShell(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Attendance Rewards', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), gradient: LinearGradient(colors: [Colors.green.withOpacity(0.12), Colors.blue.withOpacity(0.06)])),
          child: Row(children: const [Icon(Icons.emoji_events, color: Colors.green), SizedBox(width: 8), Expanded(child: Text('Recognition: 3 Months Perfect\n+50 XP Earned', style: TextStyle(fontWeight: FontWeight.w600)))],),
        ),
        const SizedBox(height: 12),
        Row(children: [Expanded(child: LinearProgressIndicator(value: 0.6, color: Colors.green)), const SizedBox(width: 8), const Text('60%')]),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [CircleAvatar(radius: 12, backgroundColor: Colors.green, child: const Icon(Icons.check, size: 14, color: Colors.white)), const SizedBox(width: 6), const Text('Mon')]),
          Row(children: [CircleAvatar(radius: 12, backgroundColor: Colors.green, child: const Icon(Icons.check, size: 14, color: Colors.white)), const SizedBox(width: 6), const Text('Tue')]),
          Row(children: [CircleAvatar(radius: 12, backgroundColor: Colors.green, child: const Icon(Icons.check, size: 14, color: Colors.white)), const SizedBox(width: 6), const Text('Wed')]),
          Row(children: [CircleAvatar(radius: 12, backgroundColor: Colors.grey, child: const Icon(Icons.close, size: 14, color: Colors.white)), const SizedBox(width: 6), const Text('Thu')]),
          Row(children: [CircleAvatar(radius: 12, backgroundColor: Colors.grey, child: const Icon(Icons.close, size: 14, color: Colors.white)), const SizedBox(width: 6), const Text('Fri')]),
        ]),
      ]),
    );
  }

  Widget _buildTimelineCard() {
    return _buildCardShell(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Today's Timeline", style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Column(
          children: _timeline.map((t) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: t.status == _TimelineStatus.checkedIn ? Colors.green.withOpacity(0.08) : (t.status == _TimelineStatus.checkedOut ? Colors.red.withOpacity(0.06) : Colors.grey.withOpacity(0.06)), borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                CircleAvatar(radius: 16, backgroundColor: t.status == _TimelineStatus.checkedIn ? Colors.green : (t.status == _TimelineStatus.checkedOut ? Colors.red : Colors.grey), child: Icon(t.status == _TimelineStatus.checkedIn ? Icons.login : (t.status == _TimelineStatus.checkedOut ? Icons.logout : Icons.hourglass_empty), color: Colors.white, size: 16)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(height: 4), Text(t.time != null ? DateFormat('h:mm a').format(t.time!) : 'Currently active', style: const TextStyle(color: Colors.black54))])),
                if (t.status == _TimelineStatus.pending) Icon(Icons.more_horiz, color: Colors.grey) else Icon(Icons.check_circle, color: Colors.green)
              ]),
            );
          }).toList(),
        ),
      ]),
    );
  }

  Widget _buildLeaveCard() {
    return _buildCardShell(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Apply for Leave', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(labelText: 'Leave Date', suffixIcon: IconButton(icon: const Icon(Icons.calendar_today), onPressed: _pickLeaveDate)),
          controller: TextEditingController(text: _leaveDate != null ? DateFormat('dd/MM/yyyy').format(_leaveDate!) : ''),
        ),
        const SizedBox(height: 12),
        TextFormField(controller: _leaveReasonController, maxLines: 4, decoration: const InputDecoration(labelText: 'Reason', hintText: 'Enter reason for leave...')),
        const SizedBox(height: 12),
        ElevatedButton.icon(onPressed: _submitLeave, icon: const Icon(Icons.send), label: const Text('Submit Leave Request'), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14))),
        const SizedBox(height: 12),
        if (_leavePending)
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.yellow.withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Row(children: const [Icon(Icons.info, color: Colors.orange), SizedBox(width: 8), Expanded(child: Text('Leave Request Pending\nApplied for Dec 25, 2024 - Holiday'))])),
      ]),
    );
  }
}

enum _TimelineStatus { checkedIn, checkedOut, pending }

class _TimelineItem {
  final String title;
  final DateTime? time;
  final _TimelineStatus status;
  _TimelineItem({required this.title, required this.time, required this.status});
}
