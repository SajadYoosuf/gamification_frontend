import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:novox_edtech_gamification/providers/course_provider.dart';
import 'package:novox_edtech_gamification/providers/employee_provider.dart';
import 'package:novox_edtech_gamification/model/employee_model.dart';
import 'package:intl/intl.dart';

class EmployeeForm extends StatefulWidget {
  final Function(EmployeeModal) onSubmit;
  final EmployeeModal? initialData;

  const EmployeeForm({
    Key? key,
    required this.onSubmit,
    this.initialData,
  }) : super(key: key);

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  // All form state (controllers, selections, validators) moved to EmployeeProvider.

  @override
  void initState() {
    super.initState();
    // Initialize provider form state from any provided initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EmployeeProvider>(context, listen: false);
      provider.initForm(widget.initialData);
    });
  }

  @override
  void dispose() {
    // Provider owns controllers; do not dispose them here to avoid double dispose.
    super.dispose();
  }
 @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only fetch when the widget is first inserted
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    if (!courseProvider.isLoading && courseProvider.courses.isEmpty) {
      courseProvider.fetchCourses();
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        Provider.of<EmployeeProvider>(context, listen: false)
            .joiningDateController
            .text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    if (provider.formKey.currentState?.validate() ?? false) {
      final employee = provider.buildEmployeeFromForm(initialData: widget.initialData);
      widget.onSubmit(employee);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmployeeProvider>(context);

    return Form(
      key: provider.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: provider.nameController,
              label: 'Full Name',
              validator: provider.validateName,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: provider.emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: provider.validateEmail,
            ),
            const SizedBox(height: 16),
            _buildPhoneField(),
            const SizedBox(height: 16),
            _buildAadharField(),
            const SizedBox(height: 16),
            _buildPanField(),
            const SizedBox(height: 16),
            _buildDateField(context),
            const SizedBox(height: 16),
            _buildDropdownField<String>(
              value: provider.selectedBloodGroup,
              hint: 'Select Blood Group',
              items: provider.bloodGroups,
              onChanged: (value) {
                provider.setSelectedBloodGroup(value);
              },
              validator: (value) => provider.validateSelection(value, 'Blood Group'),
            ),
            const SizedBox(height: 16),
            _buildDropdownField<String>(
              value: provider.selectedDesignation,
              hint: 'Select Designation',
              items: provider.designations,
              onChanged: (value) {
                provider.setSelectedDesignation(value);
              },
              validator: (value) => provider.validateSelection(value, 'Designation'),
            ),
            const SizedBox(height: 16),
            _buildCourseDropdown(),
            const SizedBox(height: 16),
            _buildTextField(
              controller: provider.emergencyContactController,
              label: 'Emergency Contact Name',
              validator: (value) => provider.validateNotEmpty(value, 'Emergency Contact Name'),
            ),
            const SizedBox(height: 16),
            _buildPhoneField(
              controller: provider.emergencyNumberController,
              label: 'Emergency Contact Number',
              isEmergency: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: provider.relationshipController,
              label: 'Relationship with Emergency Contact',
              validator: (value) => provider.validateNotEmpty(value, 'Relationship'),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: provider.addressController,
              label: 'Address',
              maxLines: 3,
              validator: (value) => provider.validateNotEmpty(value, 'Address'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save Employee'),
            ),
          ],
        ),
      ),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildPhoneField({
    TextEditingController? controller,
    String? label,
    bool isEmergency = false,
  }) {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    final phoneController = controller ?? provider.phoneController;
    final fieldLabel = label ?? 'Phone Number';
    
    return TextFormField(
      controller: phoneController,
      decoration: InputDecoration(
        labelText: fieldLabel,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixText: '+91 ', // Default to India country code
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      keyboardType: TextInputType.phone,
      validator: Provider.of<EmployeeProvider>(context, listen: false).validatePhone,
    );
  }

  Widget _buildAadharField() {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    return TextFormField(
      controller: provider.aadharController,
      decoration: InputDecoration(
        labelText: 'Aadhar Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      keyboardType: TextInputType.number,
      maxLength: 12,
      validator: provider.validateAadhar,
    );
  }

  Widget _buildPanField() {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    return TextFormField(
      controller: provider.panController,
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
        labelText: 'PAN Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      validator: provider.validatePAN,
    );
  }

  Widget _buildDateField(BuildContext context) {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    return TextFormField(
      controller: provider.joiningDateController,
      decoration: InputDecoration(
        labelText: 'Joining Date',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      readOnly: true,
      validator: (value) => provider.validateSelection(value, 'Joining Date'),
    );
  }

  Widget _buildDropdownField<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      items: items.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildCourseDropdown() {
  return Consumer<CourseProvider>(
      builder: (context, courseProvider, _) {
        if (courseProvider.isLoading) return const Center(child: CircularProgressIndicator());
        if (courseProvider.error != null) return Text('Error: ${courseProvider.error}');
        final courses = courseProvider.courses;
        final provider = Provider.of<EmployeeProvider>(context, listen: false);
        return _buildDropdownField<String>(
          value: provider.selectecCourseName,
          hint: 'Select Course',
          items: courses.map((course) => course.courseName).toList(),
          onChanged: (value) {
            provider.setselectecCourseName(value);
          },
          validator: (value) => provider.validateSelection(value, 'Course'),
        );
      },
    );
      
    
  }
}
