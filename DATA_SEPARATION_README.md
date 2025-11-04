# Data Separation Architecture

The dashboard now follows a clean architecture pattern with **data separated from UI**.

## 📁 File Structure

```
lib/
├── data/
│   └── dashboard_data.dart                # Data provider (separated from UI)
├── model/
│   └── dashboard_item_model.dart          # Data model
└── screens/admin/
    ├── dashboard_screen.dart              # UI only (no hardcoded data)
    └── widgets/
        └── dashboard_card_widget.dart     # Reusable widget
```

## 🎯 Architecture Benefits

### ✅ Separation of Concerns
- **Data Layer** (`dashboard_data.dart`) - Manages all dashboard data
- **Model Layer** (`dashboard_item_model.dart`) - Defines data structure
- **UI Layer** (`dashboard_screen.dart`) - Displays data only

### ✅ Easy to Maintain
- Change data without touching UI code
- Update UI without affecting data logic
- Single source of truth for dashboard data

### ✅ Testable
- Test data provider independently
- Mock data for UI testing
- Unit test business logic separately

### ✅ Scalable
- Easy to add new dashboard types
- Simple to integrate with APIs
- Support multiple roles/users

## 📊 Data Provider: `DashboardData`

Located in: `lib/data/dashboard_data.dart`

### Static Methods

#### 1. `getAdminDashboardItems()`
Returns dashboard items for Admin role.

```dart
List<DashboardItemModel> items = DashboardData.getAdminDashboardItems(
  onWeeklyStudentTap: () => print('Weekly Student tapped'),
  onTotalStudentsTap: () => print('Total Students tapped'),
  // ... other callbacks
);
```

**Returns 8 items:**
- Weekly Student attendance (70.05% ↑8.5%)
- Total students count (90.15% ↑10.0%)
- Total employs (95.05% ↑65.0%)
- Courses overview
- Today Student Attendants
- Today employ attendans
- Today student leave
- Today employee leave

---

#### 2. `getStudentDashboardItems()`
Returns dashboard items for Student role.

```dart
List<DashboardItemModel> items = DashboardData.getStudentDashboardItems(
  onMyAttendanceTap: () => print('My Attendance tapped'),
  onMyCoursesToap: () => print('My Courses tapped'),
  // ... other callbacks
);
```

**Returns 4 items:**
- My Attendance (85.5% ↑5.0%)
- My Courses (5 enrolled)
- Overall Progress (67% ↑12%)
- Upcoming Classes (3 today)

---

#### 3. `getEmployeeDashboardItems()`
Returns dashboard items for Employee role.

```dart
List<DashboardItemModel> items = DashboardData.getEmployeeDashboardItems(
  onMyAttendanceTap: () => print('My Attendance tapped'),
  onMyClassesToap: () => print('My Classes tapped'),
  // ... other callbacks
);
```

**Returns 4 items:**
- My Attendance (95.5% ↑2.5%)
- My Classes (8 assigned)
- Students Assigned (125 total)
- Pending Tasks (7 to complete)

---

#### 4. `fetchDashboardItems(String role)` (Async)
Simulates fetching data from an API.

```dart
// Async example
List<DashboardItemModel> items = await DashboardData.fetchDashboardItems('admin');
```

---

#### 5. `fromMapList(List<Map<String, dynamic>>)`
Converts API response to dashboard items.

```dart
// From API response
final response = await http.get(Uri.parse('$baseUrl/dashboard'));
final List<dynamic> data = json.decode(response.body);
final items = DashboardData.fromMapList(data);
```

## 🔄 How It Works

### 1. UI Requests Data

```dart
// In dashboard_screen.dart
void _initializeDashboardItems() {
  switch (widget.role.toLowerCase()) {
    case 'admin':
      _dashboardItems = DashboardData.getAdminDashboardItems(
        onWeeklyStudentTap: () => _handleCardTap('Weekly Student'),
        // ... callbacks
      );
      break;
    case 'student':
      _dashboardItems = DashboardData.getStudentDashboardItems(
        // ... callbacks
      );
      break;
    // ... other roles
  }
}
```

### 2. Data Provider Returns Data

```dart
// In dashboard_data.dart
static List<DashboardItemModel> getAdminDashboardItems({...}) {
  return [
    DashboardItemModel(
      title: 'Weekly Student',
      subtitle: 'attendance graph',
      value: '70.05%',
      // ... all properties
    ),
    // ... more items
  ];
}
```

### 3. UI Displays Data

```dart
// In dashboard_screen.dart
GridView.builder(
  itemCount: _dashboardItems.length,
  itemBuilder: (context, index) {
    return DashboardCardWidget(item: _dashboardItems[index]);
  },
)
```

## 🚀 Usage Examples

### Example 1: Basic Usage

```dart
// Get admin dashboard items
final items = DashboardData.getAdminDashboardItems(
  onWeeklyStudentTap: () => navigateToWeeklyReport(),
  onTotalStudentsTap: () => navigateToStudentsList(),
);

// Display in UI
setState(() {
  _dashboardItems = items;
});
```

### Example 2: With API Integration

```dart
// Fetch from API
Future<void> _loadDashboard() async {
  try {
    final items = await DashboardData.fetchDashboardItems(userRole);
    setState(() {
      _dashboardItems = items;
    });
  } catch (e) {
    print('Error loading dashboard: $e');
  }
}
```

### Example 3: From JSON API

```dart
// API returns JSON
final response = await http.get(Uri.parse('$baseUrl/dashboard'));
final List<dynamic> jsonData = json.decode(response.body);

// Convert to models
final items = DashboardData.fromMapList(
  jsonData.cast<Map<String, dynamic>>()
);

setState(() {
  _dashboardItems = items;
});
```

### Example 4: Custom Data Source

```dart
// Create your own data provider
class CustomDashboardData {
  static List<DashboardItemModel> getCustomItems() {
    return [
      DashboardItemModel.fromMap({
        'title': 'Custom Metric',
        'subtitle': 'description',
        'value': '100%',
        'icon': 'analytics',
        'iconBackgroundColor': '#E3F2FD',
        'iconColor': '#1976D2',
      }),
    ];
  }
}
```

## 📊 Role-Based Data

### Admin Dashboard (8 cards)
```
┌─────────────┬─────────────┬─────────────┐
│ Weekly      │ Total       │ Total       │
│ Student     │ Students    │ Employs     │
│ 70.05%      │ 90.15%      │ 95.05%      │
├─────────────┼─────────────┼─────────────┤
│ Courses     │ Today       │ Today       │
│ Overview    │ Students    │ Employs     │
├─────────────┼─────────────┼─────────────┤
│ Today       │ Today       │             │
│ Student     │ Employee    │             │
│ Leave       │ Leave       │             │
└─────────────┴─────────────┴─────────────┘
```

### Student Dashboard (4 cards)
```
┌─────────────┬─────────────┐
│ My          │ My          │
│ Attendance  │ Courses     │
│ 85.5%       │ 5           │
├─────────────┼─────────────┤
│ Overall     │ Upcoming    │
│ Progress    │ Classes     │
│ 67%         │ 3           │
└─────────────┴─────────────┘
```

### Employee Dashboard (4 cards)
```
┌─────────────┬─────────────┐
│ My          │ My          │
│ Attendance  │ Classes     │
│ 95.5%       │ 8           │
├─────────────┼─────────────┤
│ Students    │ Pending     │
│ Assigned    │ Tasks       │
│ 125         │ 7           │
└─────────────┴─────────────┘
```

## 🔧 Customization

### Add New Role

In `dashboard_data.dart`:

```dart
static List<DashboardItemModel> getManagerDashboardItems({
  VoidCallback? onTeamPerformanceTap,
  // ... other callbacks
}) {
  return [
    DashboardItemModel(
      title: 'Team Performance',
      subtitle: 'this quarter',
      value: '92%',
      icon: Icons.groups,
      iconBackgroundColor: const Color(0xFFE3F2FD),
      iconColor: const Color(0xFF1976D2),
      onTap: onTeamPerformanceTap,
    ),
    // ... more items
  ];
}
```

In `dashboard_screen.dart`:

```dart
case 'manager':
  _dashboardItems = DashboardData.getManagerDashboardItems(
    onTeamPerformanceTap: () => _handleCardTap('Team Performance'),
  );
  break;
```

### Modify Existing Data

Simply edit the data in `dashboard_data.dart`:

```dart
DashboardItemModel(
  title: 'Weekly Student',
  subtitle: 'attendance graph',
  value: '75.00%',  // Changed from 70.05%
  // ... rest stays the same
),
```

### Add Dynamic Data

```dart
static List<DashboardItemModel> getAdminDashboardItems({
  String? weeklyAttendance,  // Make it dynamic
  // ... other parameters
}) {
  return [
    DashboardItemModel(
      title: 'Weekly Student',
      subtitle: 'attendance graph',
      value: weeklyAttendance ?? '70.05%',  // Use parameter or default
      // ...
    ),
  ];
}
```

## 🔄 Migration from Old Code

### Before (Data in UI)
```dart
// dashboard_screen.dart
void _initializeDashboardItems() {
  _dashboardItems = [
    DashboardItemModel(
      title: 'Weekly Student',
      subtitle: 'attendance graph',
      value: '70.05%',
      // ... 100+ lines of hardcoded data
    ),
  ];
}
```

### After (Data Separated)
```dart
// dashboard_screen.dart
void _initializeDashboardItems() {
  _dashboardItems = DashboardData.getAdminDashboardItems(
    onWeeklyStudentTap: () => _handleCardTap('Weekly Student'),
  );
}

// dashboard_data.dart
static List<DashboardItemModel> getAdminDashboardItems({...}) {
  return [/* all data here */];
}
```

## 📈 Benefits Summary

| Aspect | Before | After |
|--------|--------|-------|
| **Data Location** | Mixed with UI | Separate file |
| **Maintainability** | Hard to change | Easy to update |
| **Testability** | Difficult | Simple |
| **Reusability** | Limited | High |
| **API Integration** | Complex | Straightforward |
| **Role Support** | Single | Multiple |

## 🎯 Best Practices

1. **Keep UI Clean**: UI should only display data, not create it
2. **Single Source**: All dashboard data comes from `DashboardData`
3. **Type Safety**: Use models, not raw maps in UI
4. **Callbacks**: Pass callbacks from UI to data layer
5. **Async Ready**: Use `fetchDashboardItems()` for API calls
6. **Role-Based**: Different data for different roles
7. **Testable**: Easy to mock and test

## 🔮 Future Enhancements

- [ ] Add caching layer
- [ ] Implement real API integration
- [ ] Add data refresh mechanism
- [ ] Support offline mode
- [ ] Add data validation
- [ ] Implement error handling
- [ ] Add loading states
- [ ] Support real-time updates

---

**Clean Architecture = Maintainable Code** 🎉
