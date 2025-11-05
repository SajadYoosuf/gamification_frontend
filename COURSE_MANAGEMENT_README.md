# Course Management Module

A fully responsive course management interface with statistics dashboard and course cards, built with clean, modular code architecture.

## 📁 File Structure

```
lib/
├── model/
│   └── course_model.dart                          # Course data model
└── screens/admin/
    ├── course_management.dart                     # Main screen
    └── widgets/
        ├── course_statistics_card.dart            # Statistics card widget
        └── course_card_widget.dart                # Course card widget
```

## 🎯 Features

### ✨ Responsive Design
- **Mobile (≤600px)**: Single column layout with stacked statistics
- **Tablet (601-1200px)**: 2 column grid for courses, 2x2 statistics grid
- **Desktop (>1200px)**: 3 column grid for courses, 4 column statistics row

### 📊 Statistics Dashboard
- **Total Courses**: Count of all courses
- **Active Students**: Sum of all enrolled students
- **Avg. Completion**: Average completion rate across courses
- **Total Revenue**: Calculated from course prices and enrollments

### 🎓 Course Cards Display
- Course icon with color-coded background
- Status badge (Active/Draft/Archived)
- Course title and description
- Duration, active students count, and price
- Click to view/edit course details

### 🎨 Visual Features
- Color-coded course icons by subject:
  - **Blue**: Book/General courses
  - **Purple**: Science/Physics
  - **Green**: Chemistry/Biology
  - **Orange**: Biology
  - **Teal**: Computer Science
- Status badges:
  - **Green**: Active courses
  - **Orange**: Draft courses
  - **Red**: Archived courses
- Clean, modern card design
- Smooth hover effects

## 📱 Responsive Breakpoints

```dart
Mobile:   screenWidth <= 600px   (1 column)
Tablet:   600px < screenWidth <= 1200px   (2 columns)
Desktop:  screenWidth > 1200px   (3 columns)
```

## 🎨 Design Specifications

### Colors
- **Primary Blue**: `#4A90E2`
- **Dark Text**: `#2C3E50`
- **Gray Text**: `#7F8C8D`
- **Light Gray**: `#95A5A6`
- **Background**: `#FFFFFF`
- **Border**: `#E0E0E0`

### Course Icon Colors
- **Book (Blue)**: Background `#E3F2FD`, Icon `#1976D2`
- **Science (Purple)**: Background `#F3E5F5`, Icon `#7B1FA2`
- **Chemistry (Green)**: Background `#E8F5E9`, Icon `#388E3C`
- **Biology (Orange)**: Background `#FFF3E0`, Icon `#F57C00`
- **Computer (Teal)**: Background `#E0F2F1`, Icon `#00796B`

### Status Badge Colors
- **Active**: Background `#E8F5E9`, Text `#4CAF50`
- **Draft**: Background `#FFF3E0`, Text `#FFA726`
- **Archived**: Background `#FFEBEE`, Text `#EF5350`

## 🚀 Usage

### Basic Implementation

```dart
import 'package:your_app/screens/admin/course_management.dart';

// Navigate to course management
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => CourseManagement()),
);
```

### With Custom Data

```dart
// In course_management.dart, replace _initializeDummyData() with:
Future<void> _loadCourses() async {
  final response = await CourseService.fetchCourses();
  setState(() {
    _courses = response.map((json) => 
      CourseModel.fromJson(json)
    ).toList();
    _calculateStatistics();
  });
}
```

## 📊 CourseModel Properties

```dart
CourseModel(
  id: 'CRS001',                              // Unique course ID
  title: 'Advanced Mathematics',             // Course name
  description: 'Comprehensive math...',      // Course description
  duration: '12 months',                     // Course duration
  activeStudents: 85,                        // Currently enrolled
  totalStudents: 100,                        // Total capacity
  price: 299.0,                              // Course price
  status: 'Active',                          // Active/Draft/Archived
  iconType: 'book',                          // Icon identifier
  imageUrl: 'url',                           // Optional thumbnail
)
```

## 🎯 Component Breakdown

### 1. **course_management.dart**
Main screen that manages state and coordinates widgets.

**Responsibilities:**
- State management
- Data initialization
- Statistics calculation
- Course grid layout
- Action handling

**Key Methods:**
- `_initializeDummyData()` - Sets up sample courses
- `_calculateStatistics()` - Computes metrics
- `_handleAddCourse()` - Opens course creation
- `_handleCourseTap(CourseModel)` - Opens course details

---

### 2. **course_statistics_card.dart**
Reusable widget for displaying a single statistic.

**Props:**
- `title` - Statistic label
- `value` - Statistic value
- `icon` - Icon to display
- `iconBackgroundColor` - Icon container color
- `iconColor` - Icon color

**Features:**
- Responsive sizing
- Clean card design
- Icon with colored background

---

### 3. **course_card_widget.dart**
Reusable widget for displaying course information.

**Props:**
- `course` - CourseModel instance
- `onTap` - Callback when card is tapped

**Features:**
- Dynamic icon based on course type
- Status badge
- Course details display
- Responsive layout
- Touch feedback

---

### 4. **course_model.dart**
Data model with JSON serialization.

**Methods:**
- `fromJson()` - Create from API response
- `toJson()` - Convert for API request
- `copyWith()` - Create modified copy
- `toString()` - Debug representation

## 📱 Mobile Layout

On mobile devices, courses stack vertically:

```
┌─────────────────────────────────────┐
│ Course Management                   │
│ Create and manage courses           │
│ [+ Add Course]                      │
├─────────────────────────────────────┤
│ [📚] Total Courses: 12              │
├─────────────────────────────────────┤
│ [👥] Active Students: 248           │
├─────────────────────────────────────┤
│ [📊] Avg. Completion: 78%           │
├─────────────────────────────────────┤
│ [💰] Total Revenue: $24,500         │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ [📖] [Active]                   │ │
│ │ Advanced Mathematics            │ │
│ │ Comprehensive math course...    │ │
│ │ Duration: 12 months             │ │
│ │ Students: 85 active             │ │
│ │ Price: $299                     │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

## 💻 Desktop Layout

On desktop, courses display in a 3-column grid:

```
┌────────────────────────────────────────────────────────────────┐
│ Course Management                          [+ Add Course]      │
│ Create and manage educational courses                         │
├────────────────────────────────────────────────────────────────┤
│ [📚] Total  │ [👥] Active  │ [📊] Avg.    │ [💰] Total       │
│     12      │     248      │     78%      │     $24,500      │
├────────────────────────────────────────────────────────────────┤
│ ┌──────────┐  ┌──────────┐  ┌──────────┐                     │
│ │[📖][Act] │  │[🔬][Act] │  │[⚗️][Act] │                     │
│ │Advanced  │  │Physics   │  │Organic   │                     │
│ │Math      │  │Pro       │  │Chemistry │                     │
│ └──────────┘  └──────────┘  └──────────┘                     │
│ ┌──────────┐  ┌──────────┐                                   │
│ │[🌸][Dft] │  │[💻][Act] │                                   │
│ │Biology   │  │Computer  │                                   │
│ │Fund.     │  │Science   │                                   │
│ └──────────┘  └──────────┘                                   │
└────────────────────────────────────────────────────────────────┘
```

## 🔧 Customization

### Add New Course Icon Type

In `course_card_widget.dart`:

```dart
case 'your_type':
  backgroundColor = const Color(0xFFYOURCOLOR);
  iconColor = const Color(0xFFYOURCOLOR);
  icon = Icons.your_icon;
  break;
```

### Change Statistics

Modify the statistics calculation in `course_management.dart`:

```dart
void _calculateStatistics() {
  _totalCourses = _courses.length;
  _activeStudents = _courses.fold(0, (sum, c) => sum + c.activeStudents);
  // Add your custom calculations
}
```

### Modify Grid Layout

Change the column count logic:

```dart
int crossAxisCount;
if (isMobile) {
  crossAxisCount = 1;  // Change to 2 for 2 columns on mobile
} else if (isTablet) {
  crossAxisCount = 2;  // Change to 3 for 3 columns on tablet
} else {
  crossAxisCount = 3;  // Change to 4 for 4 columns on desktop
}
```

## 🐛 Troubleshooting

**Issue**: Cards not displaying correctly  
**Solution**: Check that CourseModel data is properly initialized

**Issue**: Statistics showing 0  
**Solution**: Ensure `_calculateStatistics()` is called after data load

**Issue**: Grid layout looks wrong  
**Solution**: Verify screen width breakpoints and crossAxisCount logic

**Issue**: Icons not showing  
**Solution**: Check iconType matches the switch cases in `_buildCourseIcon()`

## 📈 Performance Tips

1. **Lazy Loading**: For large course lists, implement pagination
2. **Image Caching**: Use cached network images for course thumbnails
3. **Memoization**: Cache calculated statistics
4. **Debouncing**: Add debounce to search/filter operations

## 🔄 API Integration Example

```dart
class CourseService {
  static Future<List<CourseModel>> fetchCourses() async {
    final response = await http.get(
      Uri.parse('$baseUrl/courses'),
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CourseModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load courses');
  }
  
  static Future<CourseModel> createCourse(CourseModel course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(course.toJson()),
    );
    
    if (response.statusCode == 201) {
      return CourseModel.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create course');
  }
  
  static Future<void> updateCourse(CourseModel course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/courses/${course.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(course.toJson()),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to update course');
    }
  }
  
  static Future<void> deleteCourse(String courseId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/courses/$courseId'),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to delete course');
    }
  }
}
```

## 🔄 Future Enhancements

- [ ] Course creation form
- [ ] Course editing functionality
- [ ] Search and filter courses
- [ ] Sort by various criteria
- [ ] Bulk operations
- [ ] Course analytics dashboard
- [ ] Student enrollment management
- [ ] Course content management
- [ ] Certificate generation
- [ ] Course reviews and ratings
- [ ] Instructor assignment
- [ ] Course categories/tags
- [ ] Import/Export courses

## 📊 Statistics Calculation

### Total Revenue Calculation
```dart
_totalRevenue = _courses.fold(
  0,
  (sum, course) => sum + (course.price * course.activeStudents),
);
```

### Average Completion Rate
In a real application, this would be calculated from actual student progress data:

```dart
// Example calculation
double totalCompletion = 0;
int totalStudents = 0;

for (var course in _courses) {
  for (var student in course.students) {
    totalCompletion += student.completionPercentage;
    totalStudents++;
  }
}

_avgCompletion = (totalCompletion / totalStudents).round();
```

## 🎓 Best Practices Used

✅ **Responsive Design** - Adapts to all screen sizes  
✅ **Clean Code** - Well-commented and organized  
✅ **Separation of Concerns** - Model, View, Widget separation  
✅ **Reusability** - Widgets can be used independently  
✅ **Type Safety** - Proper Dart types throughout  
✅ **Performance** - Efficient rendering with GridView  
✅ **Accessibility** - Touch targets and readable text  
✅ **Scalability** - Easy to add new features  

## 🔐 Security Considerations

- Validate course data on server before saving
- Implement role-based access control
- Sanitize user inputs
- Encrypt sensitive data
- Implement audit logging
- Rate limit API calls

## 🎨 Design Patterns

- **Factory Pattern**: CourseModel.fromJson()
- **Builder Pattern**: Widget composition
- **Observer Pattern**: State management with setState
- **Strategy Pattern**: Different layouts for different screen sizes

---

**Built with ❤️ for clean, maintainable, and responsive code**
