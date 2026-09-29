import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/education.dart';
import '../../services/admin_education_service.dart';

class AdminEducationScreen extends StatefulWidget {
  const AdminEducationScreen({super.key});

  @override
  State<AdminEducationScreen> createState() =>
      _AdminEducationScreenState();
}

class _AdminEducationScreenState
    extends State<AdminEducationScreen> {
  final AdminEducationService _service = AdminEducationService();

  late Future<List<Education>> _educationFuture;

  @override
  void initState() {
    super.initState();
    _loadEducation();
  }

  void _loadEducation() {
    _educationFuture = _service.fetchEducation();
  }

  Future<void> _refreshEducation() async {
    setState(() {
      _loadEducation();
    });

    await _educationFuture;
  }

  Future<void> _deleteEducation(Education education) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          title: const Text(
            'Delete education?',
            style: TextStyle(
              color: AppTheme.textPrimary,
            ),
          ),
          content: Text(
            'This will hide "${education.degree}" from the public portfolio.',
            style: const TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _service.deleteEducation(education.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Education deleted successfully.',
          ),
        ),
      );

      await _refreshEducation();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst(
                  'Exception: ',
                  '',
                ),
          ),
        ),
      );
    }
  }

  Future<void> _showEducationDialog({
    Education? education,
  }) async {
    final isEditing = education != null;

    final degreeController = TextEditingController(
      text: education?.degree ?? '',
    );

    final institutionController = TextEditingController(
      text: education?.institution ?? '',
    );

    final locationController = TextEditingController(
      text: education?.location ?? '',
    );

    final startDateController = TextEditingController(
      text: education?.startDate ?? '',
    );

    final endDateController = TextEditingController(
      text: education?.endDate ?? '',
    );

    final statusController = TextEditingController(
      text: education?.status ?? '',
    );

    final descriptionController = TextEditingController(
      text: education?.description ?? '',
    );

    final orderController = TextEditingController(
      text: education?.order.toString() ?? '',
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          title: Text(
            isEditing
                ? 'Edit Education'
                : 'Add Education',
            style: const TextStyle(
              color: AppTheme.textPrimary,
            ),
          ),
          content: SizedBox(
            width: 560,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDialogField(
                    controller: degreeController,
                    label: 'Degree',
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: institutionController,
                    label: 'Institution',
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: locationController,
                    label: 'Location',
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: startDateController,
                    label: 'Start Date',
                    hint: '2023',
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: endDateController,
                    label: 'End Date',
                    hint: '2027',
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: statusController,
                    label: 'Status',
                    hint: 'Expected graduation: 2027',
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: descriptionController,
                    label: 'Description',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: orderController,
                    label: 'Order',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(
                dialogContext,
                false,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final degree = degreeController.text.trim();
                final institution =
                    institutionController.text.trim();
                final location =
                    locationController.text.trim();
                final startDate =
                    startDateController.text.trim();
                final endDate =
                    endDateController.text.trim();
                final status =
                    statusController.text.trim();
                final description =
                    descriptionController.text.trim();

                final order = int.tryParse(
                  orderController.text.trim(),
                );

                if (degree.isEmpty ||
                    institution.isEmpty ||
                    location.isEmpty ||
                    startDate.isEmpty ||
                    endDate.isEmpty ||
                    status.isEmpty ||
                    description.isEmpty ||
                    order == null ||
                    order < 1) {
                  ScaffoldMessenger.of(
                    dialogContext,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please complete all required fields.',
                      ),
                    ),
                  );
                  return;
                }

                try {
                  if (isEditing) {
                    await _service.updateEducation(
                      id: education.id,
                      degree: degree,
                      institution: institution,
                      location: location,
                      startDate: startDate,
                      endDate: endDate,
                      status: status,
                      description: description,
                      order: order,
                    );
                  } else {
                    await _service.createEducation(
                      degree: degree,
                      institution: institution,
                      location: location,
                      startDate: startDate,
                      endDate: endDate,
                      status: status,
                      description: description,
                      order: order,
                    );
                  }

                  if (!dialogContext.mounted) return;

                  Navigator.pop(
                    dialogContext,
                    true,
                  );
                } catch (error) {
                  if (!dialogContext.mounted) return;

                  ScaffoldMessenger.of(
                    dialogContext,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        error.toString().replaceFirst(
                              'Exception: ',
                              '',
                            ),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                isEditing
                    ? 'Save Changes'
                    : 'Add Education',
              ),
            ),
          ],
        );
      },
    );

    degreeController.dispose();
    institutionController.dispose();
    locationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    statusController.dispose();
    descriptionController.dispose();
    orderController.dispose();

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Education updated successfully.'
                : 'Education added successfully.',
          ),
        ),
      );

      await _refreshEducation();
    }
  }

  Widget _buildDialogField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        color: AppTheme.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(
          color: AppTheme.textSecondary,
        ),
        hintStyle: const TextStyle(
          color: AppTheme.textSecondary,
        ),
        filled: true,
        fillColor: AppTheme.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppTheme.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppTheme.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppTheme.primary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Manage Education'),
        backgroundColor: AppTheme.surface,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEducationDialog(),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Education'),
      ),
      body: FutureBuilder<List<Education>>(
        future: _educationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Unable to load education.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),
            );
          }

          final education = snapshot.data ?? [];

          if (education.isEmpty) {
            return const Center(
              child: Text(
                'No education available.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshEducation,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                100,
              ),
              itemCount: education.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = education[index];

                return Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.border,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.degree,
                                  style: const TextStyle(
                                    color:
                                        AppTheme.textPrimary,
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${item.institution} • ${item.location}',
                                  style: const TextStyle(
                                    color:
                                        AppTheme.primaryLight,
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${item.startDate} — ${item.endDate}',
                                  style: const TextStyle(
                                    color:
                                        AppTheme.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Edit',
                            onPressed: () =>
                                _showEducationDialog(
                              education: item,
                            ),
                            icon: const Icon(
                              Icons.edit_outlined,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            onPressed: () =>
                                _deleteEducation(item),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        item.status,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        item.description,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}