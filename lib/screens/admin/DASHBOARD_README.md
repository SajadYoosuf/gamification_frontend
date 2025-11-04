# Dashboard Module

A fully responsive dashboard with reusable components built using a model-based architecture.

## 📁 File Structure

```
lib/
├── model/
│   └── dashboard_item_model.dart                  # Dashboard item data model
└── screens/admin/
    ├── dashboard_screen.dart                      # Main dashboard screen
    └── widgets/
        └── dashboard_card_widget.dart             # Reusable dashboard card
```

## 🎯 Features

### ✨ Responsive Design
- **Mobile (≤600px)**: 1 column layout
- **Tablet (601-1024px)**: 2 column grid
- **Desktop (>1024px)**: 3 column grid

### 🎨 Dashboard Cards
- Icon with colored background
- Title and subtitle
- Large value display
- Trend indicator (up/down arrow with percentage)
- Action text ("Tap more info")
- Click handling

### 🔄 Reusable Model
- `DashboardItemModel` with `Map<String, dynamic>` support
- Easy to create from JSON/API data
- Supports dynamic icon and color parsing
- Type-safe with proper validation

## 📊 DashboardItemModel

### Properties

```dart
DashboardItemModel({
  required String title,              // "Weekly Student"
  required String subtitle,           // "attendance graph"
  required String value,              // "70.05%"
  required IconData icon,             // Icons.people
  required Color iconBackgroundColor, // Color(0xFFE3F2FD)
  required Color iconColor,           // Color(0xFF1976D2)
  String? trendText,                  // "8.5%"
  IconData? trendIcon,                // Icons.trending_up
  Color? trendColor,                  // Color(0xFF4CAF50)
  String? actionText,                 // "Tap more info"
  VoidCallback? onTap,                // Callback function
})
```

### Creating from Map

```dart
// From Map
final item = DashboardItemModel.fromMap({
  'title': 'Weekly Student',
  'subtitle': 'attendance graph',
  'value': '70.05%',
  'icon': 'people',
  'iconBackgroundColor': '#E3F2FD',
  'iconColor': '#1976D2',
  'trendText': '8.5%',
  'trendIcon': 'up',
  'trendColor': '#4CAF50',
  'actionText': 'Tap more info',
});

// From JSON API
final response = await http.get(Uri.parse('$baseUrl/dashboard'));
final List<dynamic> data = json.decode(response.body);
final items = data.map((json) => 
  DashboardItemModel.fromMap(json)
).toList();
```

### Supported Icon Names

```dart
'people', 'group'      → Icons.people
'person'               → Icons.person
'school'               → Icons.school
'work', 'badge'        → Icons.badge
'calendar', 'event'    → Icons.event
'book'                 → Icons.menu_book
'chart', 'analytics'   → Icons.analytics
'computer', 'desktop'  → Icons.computer
'assignment'           → Icons.assignment
```

### Supported Trend Icons

```dart
'up', 'trending_up'    → Icons.trending_up
'down', 'trending_down'→ Icons.trending_down
'flat', 'trending_flat'→ Icons.trending_flat
```

## 🎨 Design Specifications

### Colors
- **Icon Background**: Light blue `#E3F2FD`
- **Icon Color**: Blue `#1976D2`
- **Title**: Dark `#2C3E50`
- **Subtitle**: Gray `#95A5A6`
- **Value**: Dark `#2C3E50`
- **Trend Up**: Green `#4CAF50`
- **Trend Down**: Red `#EF5350`
- **Action Text**: Blue `#4A90E2`
- **Card Background**: White `#FFFFFF`
- **Border**: Light gray `#E0E0E0`

### Typography
- **Title**: 12-13px, weight 600
- **Subtitle**: 10-11px, normal
- **Value**: 24-28px, bold
- **Trend**: 11-12px, weight 600
- **Action**: 10-11px, weight 500

## 📱 Responsive Breakpoints

```dart
Mobile:   screenWidth <= 600px      (1 column, aspect ratio 2.5)
Tablet:   600px < screenWidth <= 1024px  (2 columns, aspect ratio 2.2)
Desktop:  screenWidth > 1024px      (3 columns, aspect ratio 2.0)
```

## 🚀 Usage

### Basic Implementation

```dart
import 'package:your_app/screens/admin/dashboard_screen.dart';

// Navigate to dashboard
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DashboardScreen(
      role: 'Admin',
      screenTitle: 'Dashboard',
    ),
  ),
);
```

### Creating Custom Dashboard Items

```dart
// Method 1: Direct instantiation
final item = DashboardItemModel(
  title: 'Weekly Student',
  subtitle: 'attendance graph',
  value: '70.05%',
  icon: Icons.people,
  iconBackgroundColor: const Color(0xFFE3F2FD),
  iconColor: const Color(0xFF1976D2),
  trendText: '8.5%',
  trendIcon: Icons.trending_up,
  trendColor: const Color(0xFF4CAF50),
  actionText: 'Tap more info',
  onTap: () => print('Card tapped'),
);

// Method 2: From Map
final item = DashboardItemModel.fromMap({
  'title': 'Total Students',
  'subtitle': 'students count',
  'value': '90.15%',
  'icon': 'school',
  'iconBackgroundColor': '#E3F2FD',
  'iconColor': '#1976D2',
  'trendText': '10.0%',
  'trendIcon': 'up',
  'trendColor': '#4CAF50',
  'actionText': 'Tap more info',
});
```

### Using Dashboard Card Widget

```dart
import 'package:your_app/screens/admin/widgets/dashboard_card_widget.dart';
import 'package:your_app/model/dashboard_item_model.dart';

// In your widget
DashboardCardWidget(
  item: DashboardItemModel(
    title: 'Weekly Student',
    subtitle: 'attendance graph',
    value: '70.05%',
    icon: Icons.people,
    iconBackgroundColor: const Color(0xFFE3F2FD),
    iconColor: const Color(0xFF1976D2),
    trendText: '8.5%',
    trendIcon: Icons.trending_up,
    trendColor: const Color(0xFF4CAF50),
    actionText: 'Tap more info',
    onTap: () => print('Tapped'),
  ),
)
```

## 📊 Sample Dashboard Data

The dashboard includes 9 cards by default:

### Row 1 (Metrics with values)
1. **Weekly Student** - attendance graph: 70.05% ↑8.5%
2. **Total** - students count: 90.15% ↑10.0%
3. **Total** - employs: 95.05% ↑65.0%

### Row 2 (Quick access)
4. **Courses** - overview
5. **Today** - Student Attendants
6. **Today** - employ attendans

### Row 3 (Leave tracking)
7. **Today** - student leave
8. **Today** - employee leave
9. **Courses** - overview

## 🎯 Component Breakdown

### 1. **dashboard_item_model.dart**
Data model for dashboard items.

**Key Features:**
- Type-safe properties
- `fromMap()` factory constructor
- `toMap()` serialization
- Icon and color parsing from strings
- `copyWith()` for immutability

**Methods:**
- `fromMap(Map<String, dynamic>)` - Create from map
- `toMap()` - Convert to map
- `copyWith()` - Create modified copy
- `_parseIcon(String)` - Parse icon from string
- `_parseTrendIcon(String)` - Parse trend icon
- `_parseColor(String)` - Parse color from hex

---

### 2. **dashboard_card_widget.dart**
Reusable card widget for displaying dashboard items.

**Features:**
- Responsive sizing
- Icon with colored background
- Title and subtitle
- Large value display
- Trend indicator
- Action text
- Touch feedback

**Layout:**
```
┌─────────────────────────────┐
│ Title          [Icon]        │
│ subtitle                     │
│                              │
│ 70.05%                       │
│                              │
│ ↑ 8.5%      Tap more info   │
└─────────────────────────────┘
```

---

### 3. **dashboard_screen.dart**
Main dashboard screen with responsive grid.

**Features:**
- Responsive grid layout
- Dynamic column count
- Scrollable content
- Card tap handling
- Sample data initialization

**Grid Configuration:**
- Mobile: 1 column
- Tablet: 2 columns
- Desktop: 3 columns

## 🔧 Customization

### Change Card Colors

```dart
DashboardItemModel(
  // ...
  iconBackgroundColor: const Color(0xFFYOURCOLOR),
  iconColor: const Color(0xFFYOURCOLOR),
  trendColor: const Color(0xFFYOURCOLOR),
)
```

### Add New Icons

In `dashboard_item_model.dart`, add to `_parseIcon()`:

```dart
case 'your_icon_name':
  return Icons.your_icon;
```

### Modify Grid Layout

In `dashboard_screen.dart`:

```dart
if (isMobile) {
  crossAxisCount = 1;  // Change to 2 for 2 columns
  childAspectRatio = 2.5;  // Adjust height
}
```

### Change Trend Colors

```dart
DashboardItemModel(
  // ...
  trendColor: const Color(0xFF4CAF50),  // Green for positive
  // or
  trendColor: const Color(0xFFEF5350),  // Red for negative
)
```

## 📱 Mobile Layout

```
┌─────────────────────────────┐
│ Dashboard                   │
├─────────────────────────────┤
│ ┌─────────────────────────┐ │
│ │ Weekly Student    [👥]  │ │
│ │ attendance graph        │ │
│ │ 70.05%                  │ │
│ │ ↑8.5%    Tap more info  │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ Total            [🎓]   │ │
│ │ students count          │ │
│ │ 90.15%                  │ │
│ │ ↑10.0%   Tap more info  │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

## 💻 Tablet Layout

```
┌───────────────────────────────────────┐
│ Dashboard                             │
├───────────────────────────────────────┤
│ ┌─────────────┐  ┌─────────────┐     │
│ │ Weekly [👥] │  │ Total  [🎓] │     │
│ │ 70.05%      │  │ 90.15%      │     │
│ └─────────────┘  └─────────────┘     │
│ ┌─────────────┐  ┌─────────────┐     │
│ │ Total  [👔] │  │ Courses[📚] │     │
│ │ 95.05%      │  │             │     │
│ └─────────────┘  └─────────────┘     │
└───────────────────────────────────────┘
```

## 🖥️ Desktop Layout

```
┌─────────────────────────────────────────────────┐
│ Dashboard                                       │
├─────────────────────────────────────────────────┤
│ ┌─────────┐  ┌─────────┐  ┌─────────┐         │
│ │ Week[👥]│  │ Total[🎓]│  │ Total[👔]│         │
│ │ 70.05%  │  │ 90.15%  │  │ 95.05%  │         │
│ └─────────┘  └─────────┘  └─────────┘         │
│ ┌─────────┐  ┌─────────┐  ┌─────────┐         │
│ │ Cours[📚]│  │ Today[👥]│  │ Today[💻]│         │
│ └─────────┘  └─────────┘  └─────────┘         │
│ ┌─────────┐  ┌─────────┐  ┌─────────┐         │
│ │ Today[📅]│  │ Today[📋]│  │ Cours[📊]│         │
│ └─────────┘  └─────────┘  └─────────┘         │
└─────────────────────────────────────────────────┘
```

## 🔄 API Integration Example

```dart
class DashboardService {
  static Future<List<DashboardItemModel>> fetchDashboardItems() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard'),
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => 
        DashboardItemModel.fromMap(json)
      ).toList();
    }
    throw Exception('Failed to load dashboard');
  }
}

// In dashboard_screen.dart
Future<void> _loadDashboardData() async {
  try {
    final items = await DashboardService.fetchDashboardItems();
    setState(() {
      _dashboardItems = items;
    });
  } catch (e) {
    print('Error loading dashboard: $e');
  }
}
```

## 🐛 Troubleshooting

**Issue**: Cards not displaying correctly  
**Solution**: Check that DashboardItemModel data is properly initialized

**Issue**: Grid layout looks wrong  
**Solution**: Verify screen width breakpoints and crossAxisCount logic

**Issue**: Icons not showing  
**Solution**: Ensure icon names match the cases in `_parseIcon()`

**Issue**: Colors not parsing  
**Solution**: Verify hex color format (with or without #)

## 📈 Performance Tips

1. **Lazy Loading**: For large dashboards, implement pagination
2. **Caching**: Cache dashboard data locally
3. **Memoization**: Cache calculated values
4. **Optimized Images**: Use proper image sizes for icons

## 🎓 Best Practices Used

✅ **Model-Based Architecture** - Reusable data models  
✅ **Responsive Design** - Adapts to all screen sizes  
✅ **Clean Code** - Well-commented and organized  
✅ **Separation of Concerns** - Model, View, Widget separation  
✅ **Type Safety** - Proper Dart types throughout  
✅ **Reusability** - Components can be used independently  
✅ **Flexibility** - Easy to customize and extend  
✅ **Map Support** - Works with dynamic data from APIs  

---

**Built with ❤️ for clean, maintainable, and responsive code**
