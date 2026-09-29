import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/skill.dart';
import '../../services/admin_skill_service.dart';

class AdminSkillsScreen extends StatefulWidget {
  const AdminSkillsScreen({super.key});

  @override
  State<AdminSkillsScreen> createState() => _AdminSkillsScreenState();
}

class _AdminSkillsScreenState extends State<AdminSkillsScreen> {
  final AdminSkillService _service = AdminSkillService();

  late Future<List<Skill>> _skillsFuture;

  @override
  void initState() {
    super.initState();
    _loadSkills();
  }

  void _loadSkills() {
    _skillsFuture = _service.fetchSkills();
  }

  Future<void> _refreshSkills() async {
    setState(() {
      _loadSkills();
    });

    await _skillsFuture;
  }

  Future<void> _deleteSkill(Skill skill) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          title: const Text(
            'Delete skill category?',
            style: TextStyle(color: AppTheme.textPrimary),
          ),
          content: Text(
            'This will hide "${skill.category}" from the public portfolio.',
            style: const TextStyle(color: AppTheme.textSecondary),
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
      await _service.deleteSkill(skill.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Skill category deleted successfully.'),
        ),
      );

      await _refreshSkills();
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

  Future<void> _showSkillDialog({Skill? skill}) async {
    final isEditing = skill != null;

    final categoryController = TextEditingController(
      text: skill?.category ?? '',
    );

    final iconController = TextEditingController(
      text: skill?.icon ?? '',
    );

    final skillsController = TextEditingController(
      text: skill?.skills.join(', ') ?? '',
    );

    final orderController = TextEditingController(
      text: skill?.order.toString() ?? '',
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          title: Text(
            isEditing ? 'Edit Skill Category' : 'Add Skill Category',
            style: const TextStyle(
              color: AppTheme.textPrimary,
            ),
          ),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDialogField(
                    controller: categoryController,
                    label: 'Category',
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: iconController,
                    label: 'Icon',
                    hint: 'code, phone_android, auto_awesome',
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: skillsController,
                    label: 'Skills',
                    hint: 'Java, Python, Dart, SQL',
                    maxLines: 3,
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
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final category = categoryController.text.trim();
                final icon = iconController.text.trim();
                final order = int.tryParse(
                  orderController.text.trim(),
                );

                if (category.isEmpty ||
                    icon.isEmpty ||
                    order == null ||
                    order < 1) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Category, icon and valid order are required.',
                      ),
                    ),
                  );
                  return;
                }

                final skills = skillsController.text
                    .split(',')
                    .map((item) => item.trim())
                    .where((item) => item.isNotEmpty)
                    .toList();

                if (skills.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Add at least one skill.',
                      ),
                    ),
                  );
                  return;
                }

                try {
                  if (isEditing) {
                    await _service.updateSkill(
                      id: skill.id,
                      category: category,
                      icon: icon,
                      skills: skills,
                      order: order,
                    );
                  } else {
                    await _service.createSkill(
                      category: category,
                      icon: icon,
                      skills: skills,
                      order: order,
                    );
                  }

                  if (!dialogContext.mounted) return;

                  Navigator.pop(dialogContext, true);
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
                isEditing ? 'Save Changes' : 'Add Skill',
              ),
            ),
          ],
        );
      },
    );

    categoryController.dispose();
    iconController.dispose();
    skillsController.dispose();
    orderController.dispose();

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Skill category updated successfully.'
                : 'Skill category added successfully.',
          ),
        ),
      );

      await _refreshSkills();
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
        title: const Text('Manage Skills'),
        backgroundColor: AppTheme.surface,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSkillDialog(),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Skill'),
      ),
      body: FutureBuilder<List<Skill>>(
        future: _skillsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Unable to load skills.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),
            );
          }

          final skills = snapshot.data ?? [];

          if (skills.isEmpty) {
            return const Center(
              child: Text(
                'No skill categories available.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshSkills,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                100,
              ),
              itemCount: skills.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final skill = skills[index];

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              skill.category,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Edit',
                            onPressed: () => _showSkillDialog(
                              skill: skill,
                            ),
                            icon: const Icon(
                              Icons.edit_outlined,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            onPressed: () => _deleteSkill(skill),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: skill.skills
                            .map(
                              (item) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.background,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme.border,
                                  ),
                                ),
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
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