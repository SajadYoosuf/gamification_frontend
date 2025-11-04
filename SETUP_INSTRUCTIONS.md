# Setup Instructions

## Required Package Installation

The Attendance Management module requires the `intl` package for date formatting.

### Step 1: Add Package to pubspec.yaml

Open your `pubspec.yaml` file and add the following under `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Add this line:
  intl: ^0.18.0
  
  # Your other dependencies...
  provider: ^6.0.0
  # etc...
```

### Step 2: Install the Package

Run the following command in your terminal:

```bash
flutter pub get
```

### Step 3: Verify Installation

After running `flutter pub get`, the lint errors in `attendance_table_widget.dart` should disappear.

## Alternative: Use Flutter Command

You can also add the package using the Flutter command:

```bash
flutter pub add intl
```

This will automatically add the package to your `pubspec.yaml` and run `flutter pub get`.

## Troubleshooting

### If you still see errors after installation:

1. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Restart your IDE** (VS Code, Android Studio, etc.)

3. **Check your pubspec.yaml** to ensure the package is listed correctly

4. **Verify internet connection** - Package download requires internet access

### Version Compatibility

The `intl` package version `^0.18.0` is compatible with:
- Flutter SDK: >=2.17.0
- Dart SDK: >=2.17.0

If you're using an older Flutter version, you may need to use an older version of the `intl` package:

```yaml
intl: ^0.17.0  # For older Flutter versions
```

## What the intl Package Does

The `intl` package provides internationalization and localization facilities, including:
- Date and time formatting
- Number formatting
- Message translation
- Plural and gender support

In this project, it's used specifically for date formatting in the Attendance Management module:

```dart
DateFormat('MMMM dd, yyyy').format(date)  // March 15, 2024
DateFormat('MM/dd/yyyy').format(date)     // 03/15/2024
```

## After Installation

Once the package is installed, you can run your app:

```bash
flutter run
```

All attendance management features should work correctly!
