import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/course_provider.dart';

class CourseForm extends StatefulWidget {
  const CourseForm({super.key});

  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  @override
  void initState() {
    super.initState();
    final prov = Provider.of<CourseProvider>(context, listen: false);
    prov.initForm();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(builder: (context, prov, _) {
      return Form(
        key: prov.formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: prov.courseNameController,
                decoration: const InputDecoration(labelText: 'Course name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter course name' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: prov.descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: prov.durationController,
                decoration: const InputDecoration(labelText: 'Duration'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: prov.feeController,
                decoration: const InputDecoration(labelText: 'Fee'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'Start date'),
                      controller: TextEditingController(text: prov.startDate != null ? prov.startDate!.toIso8601String().split('T').first : ''),
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: prov.startDate ?? now,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          prov.setStartDate(picked);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'End date'),
                      controller: TextEditingController(text: prov.endDate != null ? prov.endDate!.toIso8601String().split('T').first : ''),
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: prov.endDate ?? now,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          prov.setEndDate(picked);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: prov.assignedMentorController,
                decoration: const InputDecoration(labelText: 'Assigned mentor'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: prov.isSubmitting
                        ? null
                        : () async {
                            final ok = await prov.createCourse();
                            if (ok) {
                              if (mounted) Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Course created')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(prov.error ?? 'Failed to create course')));
                            }
                          },
                    child: prov.isSubmitting ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Create'),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
