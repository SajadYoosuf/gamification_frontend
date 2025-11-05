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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Full name
                _buildTextField(
                  controller: studentProv.nameController,
                  label: 'Full Name',
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter name' : null,
                ),
                const SizedBox(height: 12),

                // Guardian + Contact
                _twoColumn(
                  _buildTextField(
                    controller: studentProv.guardianController,
                    label: 'Guardian Name',
                  ),
                  _buildPhoneField(
                    controller: studentProv.contactNumberController,
                    label: 'Contact Number',
                  ),
                ),
                const SizedBox(height: 12),

                // Address + Guardian Number
                _twoColumn(
                  _buildTextField(
                    controller: studentProv.addressController,
                    label: 'Address',
                  ),
                  _buildPhoneField(
                    controller: studentProv.guardianNumberController,
                    label: 'Guardian Number',
                  ),
                ),
                const SizedBox(height: 12),

                // DOB + Aadhar
                _twoColumn(
                  TextFormField(
                    controller: studentProv.dobController,
                    decoration: const InputDecoration(labelText: 'DOB (dd/MM/yyyy)', border: OutlineInputBorder()),
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
                  _buildTextField(
                    controller: studentProv.aadharController,
                    label: 'Aadhar',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 12),

                // PAN + Blood group
                _twoColumn(
                  _buildTextField(
                    controller: studentProv.panController,
                    label: 'PAN',
                  ),
                  DropdownButtonFormField<String>(
                    value: studentProv.selectedBloodGroup ?? '',
                    decoration: InputDecoration(
                      labelText: 'Blood Group',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: ['', 'A+','A-','B+','B-','AB+','AB-','O+','O-']
                        .map((e) => DropdownMenuItem<String>(value: e, child: Text(e.isEmpty ? 'Select blood group' : e)))
                        .toList(),
                    onChanged: (v) => studentProv.selectedBloodGroup = v,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Select blood group' : null,
                  ),
                ),
                const SizedBox(height: 12),

                // Joining Date + Email
                _twoColumn(
                  TextFormField(
                    controller: studentProv.joiningDateController,
                    decoration: InputDecoration(
                      labelText: 'Joining Date',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
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
                          // show human-readable date in form
                          studentProv.joiningDateController.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                        }
                    },
                  ),
                  _buildTextField(
                    controller: studentProv.emailController,
                    label: 'Email',
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter email';
                      if (!v.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 12),

                // Course dropdown (single select)
                Consumer<CourseProvider>(
                  builder: (context, cp, __) {
                    if (!cp.isLoading && cp.courses.isEmpty) {
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
                      decoration: InputDecoration(
                        labelText: 'Course',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: dropdownValues.map((e) => DropdownMenuItem<String>(value: e, child: Text(e.isEmpty ? 'Select course' : e))).toList(),
                      onChanged: (v) => studentProv.selectedCourseName = v,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Select course' : null,
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Emergency Contact section
                Row(
                  children: const [
                    Icon(Icons.phone, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Emergency Contact', style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),

                _threeColumn(
                  _buildTextField(
                    controller: studentProv.emergencyContactController,
                    label: 'Contact Name',
                  ),
                  _buildPhoneField(
                    controller: studentProv.emergencyNumberController,
                    label: 'Emergency Number',
                  ),
                  _buildTextField(
                    controller: studentProv.relationshipController,
                    label: 'Relationship',
                  ),
                ),
                const SizedBox(height: 16),

                // Actions
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
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
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blue.shade600,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: studentProv.isSubmitting
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Register Student'),
                      ),
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

  Widget _twoColumn(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }

  Widget _threeColumn(Widget a, Widget b, Widget c) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: a),
        const SizedBox(width: 12),
        Expanded(flex: 4, child: b),
        const SizedBox(width: 12),
        Expanded(flex: 3, child: c),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildPhoneField({
    TextEditingController? controller,
    String? label,
  }) {
    final prov = Provider.of<StudentProvider>(context, listen: false);
    final phoneController = controller ?? prov.contactNumberController;
    final fieldLabel = label ?? 'Phone Number';

    return TextFormField(
      controller: phoneController,
      decoration: InputDecoration(
        labelText: fieldLabel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixText: '+91 ',
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      keyboardType: TextInputType.phone,
    );
  }
}
