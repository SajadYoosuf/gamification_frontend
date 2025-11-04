# Employee Management Module

This module provides a complete employee management interface with clean, modular code architecture.

## 📁 File Structure

```
lib/screens/admin/
├── employee_management.dart          # Main screen that combines all components
├── constants/
│   └── employee_management_constants.dart  # Centralized colors, styles, and constants
└── widgets/
    ├── statistic_card_widget.dart         # Reusable card for displaying statistics
    ├── featured_employee_card_widget.dart # Card for featured employee quick view
    └── employee_list_table_widget.dart    # Table widget with search functionality
```

## 🎯 Components Overview

### 1. **employee_management.dart**
The main screen that orchestrates all components.

**Features:**
- Page header with breadcrumb navigation
- Statistics section with 4 metric cards
- Featured employees section
- Searchable employee list table
- Dummy data initialization (ready for API integration)

**Key Methods:**
- `_initializeDummyData()` - Sets up sample employee data
- `_handleSearch(String query)` - Filters employees based on search
- `_handleAddNewEmployee()` - Placeholder for add employee functionality
- `_handleViewEmployee(String name)` - Placeholder for view employee details

---

### 2. **statistic_card_widget.dart**
A reusable card widget for displaying key metrics.

**Props:**
- `icon` - IconData for the metric
- `title` - Label for the statistic
- `value` - The main numeric value
- `trendPercentage` - Percentage change from last month
- `backgroundColor` - Card background color (optional)
- `iconColor` - Icon color (optional)
- `valueColor` - Value text color (optional)

**Usage Example:**
```dart
StatisticCardWidget(
  icon: Icons.people_outline,
  title: 'Total Employees',
  value: '26',
  trendPercentage: '+1.6%',
  iconColor: Color(0xFF4A90E2),
)
```

---

### 3. **featured_employee_card_widget.dart**
A card widget for displaying featured employee information.

**Props:**
- `imageUrl` - Employee profile picture URL (optional)
- `employeeName` - Full name of the employee
- `jobTitle` - Job position/title
- `phoneNumber` - Contact phone number
- `onViewPressed` - Callback when VIEW button is pressed

**Features:**
- Shows employee avatar (or initials if no image)
- Displays name, job title, and phone number
- Action button for viewing details
- Auto-generates initials from name

**Usage Example:**
```dart
FeaturedEmployeeCardWidget(
  employeeName: 'John Doe',
  jobTitle: 'Software Developer',
  phoneNumber: '+91 12345 67890',
  onViewPressed: () => print('View employee'),
)
```

---

### 4. **employee_list_table_widget.dart**
A comprehensive table widget for displaying employee lists.

**Includes:**
- `EmployeeModel` - Data model for employee information

**Props:**
- `employees` - List of EmployeeModel objects
- `onSearchChanged` - Callback when search text changes
- `onAddNewEmployee` - Callback for add new employee button

**Features:**
- Searchable employee list
- Sortable columns
- Color-coded badges for employment type and status
- Work model icons
- Employee avatars with initials fallback
- "New Employee" action button

**EmployeeModel Properties:**
- `id` - Employee ID
- `name` - Full name
- `jobTitle` - Job position
- `employmentType` - Full-Time, Part-Time, Intern, etc.
- `workModel` - Hybrid, Remote, On Site
- `status` - Active or Inactive
- `imageUrl` - Profile picture URL (optional)

**Usage Example:**
```dart
EmployeeListTableWidget(
  employees: employeeList,
  onSearchChanged: (query) => filterEmployees(query),
  onAddNewEmployee: () => showAddDialog(),
)
```

---

### 5. **employee_management_constants.dart**
Centralized constants for consistent styling.

**Categories:**

**Colors:**
- Primary colors (blue, dark text, gray text)
- Status colors (active, inactive)
- Employment type colors (full-time, part-time, intern, etc.)

**Spacing:**
- `standardPadding` - 20.0
- `smallSpacing` - 8.0
- `mediumSpacing` - 16.0
- `largeSpacing` - 24.0

**Border Radius:**
- `cardBorderRadius` - 12.0
- `buttonBorderRadius` - 8.0
- `badgeBorderRadius` - 16.0

**Text Styles:**
- `pageTitleStyle` - For page headings
- `sectionHeadingStyle` - For section titles
- `cardTitleStyle` - For card labels
- `largeValueStyle` - For numeric values
- And more...

**Usage Example:**
```dart
Container(
  padding: EdgeInsets.all(EmployeeManagementConstants.standardPadding),
  decoration: BoxDecoration(
    color: EmployeeManagementConstants.cardBackground,
    borderRadius: BorderRadius.circular(
      EmployeeManagementConstants.cardBorderRadius
    ),
  ),
)
```

---

## 🚀 Getting Started

### Basic Implementation

1. **Import the main screen:**
```dart
import 'package:your_app/screens/admin/employee_management.dart';
```

2. **Use in your navigation:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => EmployeeManagement()),
);
```

### Customization

**To add real data:**
Replace the `_initializeDummyData()` method in `employee_management.dart` with API calls:

```dart
Future<void> _loadEmployees() async {
  final response = await EmployeeService.getEmployees();
  setState(() {
    _allEmployees = response.map((e) => EmployeeModel.fromJson(e)).toList();
    _filteredEmployees = _allEmployees;
  });
}
```

**To customize colors:**
Modify values in `employee_management_constants.dart`:

```dart
static const Color primaryBlue = Color(0xFF4A90E2); // Change to your brand color
```

---

## 🎨 Design Principles

1. **Separation of Concerns:** Each widget has a single, clear responsibility
2. **Reusability:** Widgets can be used independently in other parts of the app
3. **Maintainability:** Constants are centralized for easy updates
4. **Documentation:** Every class and method has clear comments
5. **Beginner-Friendly:** Code is well-commented and easy to understand

---

## 📝 Code Quality Features

✅ **Meaningful Names:** Variables and methods have descriptive names  
✅ **Comments:** Every component is documented with purpose and usage  
✅ **Modular Structure:** Separate files for different concerns  
✅ **Type Safety:** Proper use of Dart types and models  
✅ **Const Constructors:** Performance optimization where possible  
✅ **Clean Architecture:** Follows Flutter best practices  

---

## 🔄 Future Enhancements

- [ ] Add employee detail screen
- [ ] Implement add/edit employee forms
- [ ] Add sorting functionality to table columns
- [ ] Implement pagination for large datasets
- [ ] Add export to CSV/PDF functionality
- [ ] Integrate with backend API
- [ ] Add employee filtering by department/status
- [ ] Implement bulk actions (delete, update)

---

## 🐛 Troubleshooting

**Issue:** Colors not showing correctly  
**Solution:** Ensure you're importing `employee_management_constants.dart`

**Issue:** Table not displaying data  
**Solution:** Check that `EmployeeModel` list is properly initialized

**Issue:** Search not working  
**Solution:** Verify `onSearchChanged` callback is properly connected

---

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Material Design Guidelines](https://material.io/design)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)

---

**Created with ❤️ for clean, maintainable code**
