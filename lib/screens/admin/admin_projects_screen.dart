import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/project.dart';
import '../../services/admin_project_service.dart';

class AdminProjectsScreen extends StatefulWidget {
  const AdminProjectsScreen({super.key});

  @override
  State<AdminProjectsScreen> createState() => _AdminProjectsScreenState();
}

class _AdminProjectsScreenState extends State<AdminProjectsScreen> {
  final AdminProjectService _service = AdminProjectService();

  late Future<List<Project>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  void _loadProjects() {
    _projectsFuture = _service.fetchProjects();
  }

  Future<void> _refreshProjects() async {
    setState(() {
      _loadProjects();
    });

    await _projectsFuture;
  }

  Future<void> _deleteProject(Project project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          title: const Text(
            'Delete project?',
            style: TextStyle(
              color: AppTheme.textPrimary,
            ),
          ),
          content: Text(
            'This will hide "${project.title}" from the public portfolio.',
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
      await _service.deleteProject(project.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Project deleted successfully.'),
        ),
      );

      await _refreshProjects();
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

  Future<void> _showProjectDialog({
    Project? project,
  }) async {
    final isEditing = project != null;

    final titleController = TextEditingController(
      text: project?.title ?? '',
    );

    final slugController = TextEditingController(
      text: project?.slug ?? '',
    );

    final descriptionController = TextEditingController(
      text: project?.description ?? '',
    );

    final technologiesController = TextEditingController(
      text: project?.technologies.join(', ') ?? '',
    );

    final projectUrlController = TextEditingController(
      text: project?.projectUrl ?? '',
    );

    final caseStudyUrlController = TextEditingController(
      text: project?.caseStudyUrl ?? '',
    );

    bool featured = project?.featured ?? false;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.surface,
              title: Text(
                isEditing ? 'Edit Project' : 'Add Project',
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
                        controller: titleController,
                        label: 'Title',
                      ),
                      const SizedBox(height: 14),
                      _buildDialogField(
                        controller: slugController,
                        label: 'Slug',
                      ),
                      const SizedBox(height: 14),
                      _buildDialogField(
                        controller: descriptionController,
                        label: 'Description',
                        maxLines: 4,
                      ),
                      const SizedBox(height: 14),
                      _buildDialogField(
                        controller: technologiesController,
                        label: 'Technologies',
                        hint: 'Flutter, FastAPI, MongoDB',
                      ),
                      const SizedBox(height: 14),
                      _buildDialogField(
                        controller: projectUrlController,
                        label: 'Project URL',
                      ),
                      const SizedBox(height: 14),
                      _buildDialogField(
                        controller: caseStudyUrlController,
                        label: 'Case Study URL',
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: featured,
                        onChanged: (value) {
                          setDialogState(() {
                            featured = value ?? false;
                          });
                        },
                        title: const Text(
                          'Featured project',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        activeColor: AppTheme.primary,
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
                    final title = titleController.text.trim();
                    final slug = slugController.text.trim();
                    final description =
                        descriptionController.text.trim();

                    if (title.isEmpty ||
                        slug.isEmpty ||
                        description.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Title, slug and description are required.',
                          ),
                        ),
                      );
                      return;
                    }

                    final technologies = technologiesController.text
                        .split(',')
                        .map((item) => item.trim())
                        .where((item) => item.isNotEmpty)
                        .toList();

                    try {
                      if (isEditing) {
                        await _service.updateProject(
                          id: project.id,
                          title: title,
                          slug: slug,
                          description: description,
                          technologies: technologies,
                          projectUrl:
                              projectUrlController.text.trim().isEmpty
                                  ? null
                                  : projectUrlController.text.trim(),
                          caseStudyUrl:
                              caseStudyUrlController.text.trim().isEmpty
                                  ? null
                                  : caseStudyUrlController.text.trim(),
                          featured: featured,
                        );
                      } else {
                        await _service.createProject(
                          title: title,
                          slug: slug,
                          description: description,
                          technologies: technologies,
                          projectUrl:
                              projectUrlController.text.trim().isEmpty
                                  ? null
                                  : projectUrlController.text.trim(),
                          caseStudyUrl:
                              caseStudyUrlController.text.trim().isEmpty
                                  ? null
                                  : caseStudyUrlController.text.trim(),
                          featured: featured,
                          order: 99,
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
                    isEditing ? 'Save Changes' : 'Add Project',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    slugController.dispose();
    descriptionController.dispose();
    technologiesController.dispose();
    projectUrlController.dispose();
    caseStudyUrlController.dispose();

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Project updated successfully.'
                : 'Project added successfully.',
          ),
        ),
      );

      await _refreshProjects();
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
        title: const Text('Manage Projects'),
        backgroundColor: AppTheme.surface,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProjectDialog(),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Project'),
      ),
      body: FutureBuilder<List<Project>>(
        future: _projectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Unable to load projects.',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),
            );
          }

          final projects = snapshot.data ?? [];

          if (projects.isEmpty) {
            return const Center(
              child: Text(
                'No projects available.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshProjects,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                100,
              ),
              itemCount: projects.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final project = projects[index];

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              project.title,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Edit',
                            onPressed: () => _showProjectDialog(
                              project: project,
                            ),
                            icon: const Icon(
                              Icons.edit_outlined,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            onPressed: () => _deleteProject(project),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        project.description,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: project.technologies
                            .map(
                              (technology) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.background,
                                  borderRadius:
                                      BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme.border,
                                  ),
                                ),
                                child: Text(
                                  technology,
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),

                      if (project.featured) ...[
                        const SizedBox(height: 14),
                        const Text(
                          'FEATURED',
                          style: TextStyle(
                            color: AppTheme.primaryLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
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