import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/student_provider.dart';
import '../../../providers/course_provider.dart';

class StudentForm extends StatefulWidget {
  const StudentForm({super.key});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  @override
  void initState() {
    super.initState();
    // initialize with empty values
    final prov = Provider.of<StudentProvider>(context, listen: false);
    prov.initForm();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StudentProvider, CourseProvider>(
      builder: (context, studentProv, courseProv, _) {
        return Form(
          key: studentProv.formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fullname
                TextFormField(
                  controller: studentProv.nameController,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter name' : null,
                ),
                const SizedBox(height: 8),

                // Guardian
                TextFormField(
                  controller: studentProv.guardianController,
                  decoration: const InputDecoration(labelText: 'Guardian name'),
                ),
                const SizedBox(height: 8),

                // Address
                TextFormField(
                  controller: studentProv.addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: 8),

                // Contact Number
                TextFormField(
                  controller: studentProv.contactNumberController,
                  decoration: const InputDecoration(labelText: 'Contact number'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 8),

                // Guardian Number
                TextFormField(
                  controller: studentProv.guardianNumberController,
                  decoration: const InputDecoration(labelText: 'Guardian number'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 8),

                // DOB (text input with optional date picker)
                TextFormField(
                  controller: studentProv.dobController,
                  decoration: const InputDecoration(labelText: 'DOB (dd/MM/yyyy)'),
                  readOnly: true,
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: DateTime(1900),
                      lastDate: now,
                    );
                    if (picked != null) {
                      studentProv.dobController.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                    }
                  },
                ),
                const SizedBox(height: 8),

                // Aadhar
                TextFormField(
                  controller: studentProv.aadharController,
                  decoration: const InputDecoration(labelText: 'Aadhar'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),

                // PAN
                TextFormField(
                  controller: studentProv.panController,
                  decoration: const InputDecoration(labelText: 'PAN'),
                ),
                const SizedBox(height: 8),

                // Blood Group dropdown
                DropdownButtonFormField<String>(
                  value: studentProv.selectedBloodGroup ?? '',
                  decoration: const InputDecoration(labelText: 'Blood Group'),
                  items: ['', 'A+','A-','B+','B-','AB+','AB-','O+','O-']
                      .map((e) => DropdownMenuItem<String>(value: e, child: Text(e.isEmpty ? 'Select blood group' : e)))
                      .toList(),
                  onChanged: (v) => studentProv.selectedBloodGroup = v,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Select blood group' : null,
                ),
                const SizedBox(height: 8),

                // Joining Date (ISO)
                TextFormField(
                  controller: studentProv.joiningDateController,
                  decoration: const InputDecoration(labelText: 'Joining Date'),
                  readOnly: true,
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      studentProv.joiningDateController.text = picked.toIso8601String();
                    }
                  },
                ),
                const SizedBox(height: 8),

                // Email
                TextFormField(
                  controller: studentProv.emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter email';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // Course dropdown
                Consumer<CourseProvider>(
                  builder: (context, cp, __) {
                    if (!cp.isLoading && cp.courses.isEmpty) {
                      // trigger fetch
                      Future.microtask(() => cp.fetchCourses());
                      return const SizedBox(height: 48, child: Align(alignment: Alignment.centerLeft, child: Text('No courses available')));
                    }
                    if (cp.isLoading) {
                      return const SizedBox(height: 48, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
                    }

                    final items = cp.courses.map((c) => c.courseName).toList();
                    final dropdownValues = <String>[''];
                    dropdownValues.addAll(items);

                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: (studentProv.selectedCourseName == null || studentProv.selectedCourseName!.isEmpty) ? '' : studentProv.selectedCourseName,
                      decoration: const InputDecoration(labelText: 'Course'),
                      items: dropdownValues.map((e) => DropdownMenuItem<String>(value: e, child: Text(e.isEmpty ? 'Select course' : e))).toList(),
                      onChanged: (v) => studentProv.selectedCourseName = v,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Select course' : null,
                    );
                  },
                ),
                const SizedBox(height: 8),

                // Emergency Contact Name
                TextFormField(
                  controller: studentProv.emergencyContactController,
                  decoration: const InputDecoration(labelText: 'Emergency Contact Name'),
                ),
                const SizedBox(height: 8),

                // Emergency Number
                TextFormField(
                  controller: studentProv.emergencyNumberController,
                  decoration: const InputDecoration(labelText: 'Emergency Number'),
                ),
                const SizedBox(height: 8),

                // Relationship
                TextFormField(
                  controller: studentProv.relationshipController,
                  decoration: const InputDecoration(labelText: 'Relationship'),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: studentProv.isSubmitting
                          ? null
                          : () async {
                              final ok = await studentProv.createStudent();
                              if (ok) {
                                if (mounted) Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student created')));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(studentProv.error ?? 'Failed to create')));
                              }
                            },
                      child: studentProv.isSubmitting ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
