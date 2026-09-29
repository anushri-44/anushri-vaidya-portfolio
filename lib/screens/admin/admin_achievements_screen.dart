import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/achievement.dart';
import '../../services/admin_achievement_service.dart';

class AdminAchievementsScreen extends StatefulWidget {
  const AdminAchievementsScreen({super.key});

  @override
  State<AdminAchievementsScreen> createState() =>
      _AdminAchievementsScreenState();
}

class _AdminAchievementsScreenState
    extends State<AdminAchievementsScreen> {
  final AdminAchievementService _service =
      AdminAchievementService();

  late Future<List<Achievement>> _achievementsFuture;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  void _loadAchievements() {
    _achievementsFuture = _service.fetchAchievements();
  }

  Future<void> _refreshAchievements() async {
    setState(() {
      _loadAchievements();
    });

    await _achievementsFuture;
  }

  Future<void> _deleteAchievement(
    Achievement achievement,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          title: const Text(
            'Delete achievement?',
            style: TextStyle(
              color: AppTheme.textPrimary,
            ),
          ),
          content: Text(
            'This will hide "${achievement.title}" from the public portfolio.',
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
      await _service.deleteAchievement(
        achievement.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Achievement deleted successfully.',
          ),
        ),
      );

      await _refreshAchievements();
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

  Future<void> _showAchievementDialog({
    Achievement? achievement,
  }) async {
    final isEditing = achievement != null;

    final iconController = TextEditingController(
      text: achievement?.icon ?? '',
    );

    final titleController = TextEditingController(
      text: achievement?.title ?? '',
    );

    final subtitleController = TextEditingController(
      text: achievement?.subtitle ?? '',
    );

    final descriptionController = TextEditingController(
      text: achievement?.description ?? '',
    );

    final orderController = TextEditingController(
      text: achievement?.order.toString() ?? '',
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          title: Text(
            isEditing
                ? 'Edit Achievement'
                : 'Add Achievement',
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
                    controller: iconController,
                    label: 'Icon',
                    hint: 'code, emoji_events, school',
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: titleController,
                    label: 'Title',
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: subtitleController,
                    label: 'Subtitle',
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
                final icon = iconController.text.trim();
                final title = titleController.text.trim();
                final subtitle =
                    subtitleController.text.trim();
                final description =
                    descriptionController.text.trim();

                final order = int.tryParse(
                  orderController.text.trim(),
                );

                if (icon.isEmpty ||
                    title.isEmpty ||
                    subtitle.isEmpty ||
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
                    await _service.updateAchievement(
                      id: achievement.id,
                      icon: icon,
                      title: title,
                      subtitle: subtitle,
                      description: description,
                      order: order,
                    );
                  } else {
                    await _service.createAchievement(
                      icon: icon,
                      title: title,
                      subtitle: subtitle,
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
                    : 'Add Achievement',
              ),
            ),
          ],
        );
      },
    );

    iconController.dispose();
    titleController.dispose();
    subtitleController.dispose();
    descriptionController.dispose();
    orderController.dispose();

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Achievement updated successfully.'
                : 'Achievement added successfully.',
          ),
        ),
      );

      await _refreshAchievements();
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
        title: const Text('Manage Achievements'),
        backgroundColor: AppTheme.surface,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAchievementDialog(),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Achievement'),
      ),
      body: FutureBuilder<List<Achievement>>(
        future: _achievementsFuture,
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
                'Unable to load achievements.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),
            );
          }

          final achievements = snapshot.data ?? [];

          if (achievements.isEmpty) {
            return const Center(
              child: Text(
                'No achievements available.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshAchievements,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                100,
              ),
              itemCount: achievements.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final achievement = achievements[index];

                return Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.border,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.emoji_events_outlined,
                        color: AppTheme.primaryLight,
                        size: 30,
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              achievement.title,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              achievement.subtitle,
                              style: const TextStyle(
                                color: AppTheme.primaryLight,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              achievement.description,
                              style: const TextStyle(
                                color:
                                    AppTheme.textSecondary,
                                fontSize: 14,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Edit',
                        onPressed: () =>
                            _showAchievementDialog(
                          achievement: achievement,
                        ),
                        icon: const Icon(
                          Icons.edit_outlined,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        onPressed: () =>
                            _deleteAchievement(
                          achievement,
                        ),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
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