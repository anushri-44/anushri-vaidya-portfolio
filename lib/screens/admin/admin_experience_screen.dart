import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/experience.dart';
import '../../services/admin_experience_service.dart';

class AdminExperienceScreen extends StatefulWidget {
  const AdminExperienceScreen({super.key});

  @override
  State<AdminExperienceScreen> createState() =>
      _AdminExperienceScreenState();
}

class _AdminExperienceScreenState extends State<AdminExperienceScreen> {
  final AdminExperienceService _service = AdminExperienceService();

  late Future<List<Experience>> _experienceFuture;

  @override
  void initState() {
    super.initState();
    _loadExperience();
  }

  void _loadExperience() {
    _experienceFuture = _service.fetchExperience();
  }

  Future<void> _refreshExperience() async {
    setState(() {
      _loadExperience();
    });

    await _experienceFuture;
  }

  Future<void> _deleteExperience(Experience experience) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          title: const Text(
            'Delete experience?',
            style: TextStyle(
              color: AppTheme.textPrimary,
            ),
          ),
          content: Text(
            'This will hide "${experience.role}" from the public portfolio.',
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
      await _service.deleteExperience(experience.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Experience deleted successfully.'),
        ),
      );

      await _refreshExperience();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  Future<void> _showExperienceDialog({
    Experience? experience,
  }) async {
    final isEditing = experience != null;

    final roleController = TextEditingController(
      text: experience?.role ?? '',
    );
    final companyController = TextEditingController(
      text: experience?.company ?? '',
    );
    final locationController = TextEditingController(
      text: experience?.location ?? '',
    );
    final startDateController = TextEditingController(
      text: experience?.startDate ?? '',
    );
    final endDateController = TextEditingController(
      text: experience?.endDate ?? '',
    );
    final descriptionController = TextEditingController(
      text: experience?.description ?? '',
    );
    final bulletsController = TextEditingController(
      text: experience?.bullets.join('\n') ?? '',
    );
    final technologiesController = TextEditingController(
      text: experience?.technologies.join(', ') ?? '',
    );
    final orderController = TextEditingController(
      text: experience?.order.toString() ?? '',
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          title: Text(
            isEditing
                ? 'Edit Experience'
                : 'Add Experience',
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
                    controller: roleController,
                    label: 'Role',
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: companyController,
                    label: 'Company',
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
                    hint: 'Aug 2025',
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: endDateController,
                    label: 'End Date',
                    hint: 'Dec 2025',
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: descriptionController,
                    label: 'Description',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: bulletsController,
                    label: 'Bullets',
                    hint: 'One bullet per line',
                    maxLines: 6,
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: technologiesController,
                    label: 'Technologies',
                    hint: 'Flutter, Dart, Firebase',
                    maxLines: 2,
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
                final role = roleController.text.trim();
                final company = companyController.text.trim();
                final location = locationController.text.trim();
                final startDate =
                    startDateController.text.trim();
                final endDate =
                    endDateController.text.trim();
                final description =
                    descriptionController.text.trim();

                final order = int.tryParse(
                  orderController.text.trim(),
                );

                if (role.isEmpty ||
                    company.isEmpty ||
                    location.isEmpty ||
                    startDate.isEmpty ||
                    endDate.isEmpty ||
                    description.isEmpty ||
                    order == null ||
                    order < 1) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please complete all required fields.',
                      ),
                    ),
                  );
                  return;
                }

                final bullets = bulletsController.text
                    .split('\n')
                    .map((item) => item.trim())
                    .where((item) => item.isNotEmpty)
                    .toList();

                final technologies = technologiesController.text
                    .split(',')
                    .map((item) => item.trim())
                    .where((item) => item.isNotEmpty)
                    .toList();

                try {
                  if (isEditing) {
                    await _service.updateExperience(
                      id: experience.id,
                      role: role,
                      company: company,
                      location: location,
                      startDate: startDate,
                      endDate: endDate,
                      description: description,
                      bullets: bullets,
                      technologies: technologies,
                      order: order,
                    );
                  } else {
                    await _service.createExperience(
                      role: role,
                      company: company,
                      location: location,
                      startDate: startDate,
                      endDate: endDate,
                      description: description,
                      bullets: bullets,
                      technologies: technologies,
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

                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        error
                            .toString()
                            .replaceFirst('Exception: ', ''),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                isEditing
                    ? 'Save Changes'
                    : 'Add Experience',
              ),
            ),
          ],
        );
      },
    );

    roleController.dispose();
    companyController.dispose();
    locationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    descriptionController.dispose();
    bulletsController.dispose();
    technologiesController.dispose();
    orderController.dispose();

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Experience updated successfully.'
                : 'Experience added successfully.',
          ),
        ),
      );

      await _refreshExperience();
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
        title: const Text('Manage Experience'),
        backgroundColor: AppTheme.surface,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showExperienceDialog(),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Experience'),
      ),
      body: FutureBuilder<List<Experience>>(
        future: _experienceFuture,
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
                'Unable to load experience.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),
            );
          }

          final experience = snapshot.data ?? [];

          if (experience.isEmpty) {
            return const Center(
              child: Text(
                'No experience available.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshExperience,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                100,
              ),
              itemCount: experience.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = experience[index];

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
                                  item.role,
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
                                  '${item.company} • ${item.location}',
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
                                _showExperienceDialog(
                              experience: item,
                            ),
                            icon: const Icon(
                              Icons.edit_outlined,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            onPressed: () =>
                                _deleteExperience(item),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Text(
                        item.description,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),

                      if (item.bullets.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ...item.bullets.map(
                          (bullet) => Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 8,
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '• ',
                                  style: TextStyle(
                                    color:
                                        AppTheme.primaryLight,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    bullet,
                                    style:
                                        const TextStyle(
                                      color: AppTheme
                                          .textSecondary,
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      if (item.technologies.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: item.technologies
                              .map(
                                (technology) => Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.background,
                                    borderRadius:
                                        BorderRadius.circular(
                                      8,
                                    ),
                                    border: Border.all(
                                      color:
                                          AppTheme.border,
                                    ),
                                  ),
                                  child: Text(
                                    technology,
                                    style:
                                        const TextStyle(
                                      color: AppTheme
                                          .textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
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