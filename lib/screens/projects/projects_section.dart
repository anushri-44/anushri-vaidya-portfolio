import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme.dart';
import '../../models/project.dart';
import '../../services/portfolio_api_service.dart';

class ProjectsSection extends StatelessWidget {
  static final GlobalKey sectionKey = GlobalKey();

  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      key: sectionKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PROJECTS',
            style: TextStyle(
              color: AppTheme.primaryLight,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Things I’ve built.',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: isMobile ? 32 : 44,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 50),

          FutureBuilder<List<Project>>(
            future: PortfolioApiService.fetchProjects(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const _ProjectsLoading();
              }

              if (snapshot.hasError) {
                return _ProjectsError(
                  message: snapshot.error.toString(),
                );
              }

              final projects = snapshot.data ?? [];

              if (projects.isEmpty) {
                return const _ProjectsEmpty();
              }

              final featuredProjects = projects
                  .where((project) => project.featured)
                  .toList();

              final otherProjects = projects
                  .where((project) => !project.featured)
                  .toList()
                ..sort(
                  (a, b) => a.order.compareTo(b.order),
                );

              final featuredProject =
                  featuredProjects.isNotEmpty
                      ? featuredProjects.first
                      : projects.first;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FeaturedProject(
                    project: featuredProject,
                  ),

                  const SizedBox(height: 24),

                  if (otherProjects.isNotEmpty)
                    isMobile
                        ? Column(
                            children: otherProjects
                                .map(
                                  (project) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 24,
                                    ),
                                    child: _ProjectCard(
                                      project: project,
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        : Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Expanded(
  child: _ProjectCard(
    project: otherProjects.isNotEmpty
        ? otherProjects[0]
        : null,
  ),
),

                              if (otherProjects.length > 1) ...[
                                const SizedBox(width: 24),

                                Expanded(
                                  child: _ProjectCard(
                                    project: otherProjects[1],
                                  ),
                                ),
                              ],
                            ],
                          ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// FEATURED PROJECT
// ============================================================================

class _FeaturedProject extends StatefulWidget {
  final Project project;

  const _FeaturedProject({
    required this.project,
  });

  @override
  State<_FeaturedProject> createState() =>
      _FeaturedProjectState();
}

class _FeaturedProjectState extends State<_FeaturedProject> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovered = true);
      },
      onExit: (_) {
        setState(() => isHovered = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        padding: EdgeInsets.all(
          isMobile ? 24 : 36,
        ),
        decoration: BoxDecoration(
          color: isHovered
              ? AppTheme.surfaceLight
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isHovered
                ? AppTheme.primary.withValues(alpha: 0.5)
                : AppTheme.border,
          ),
        ),
        child: isMobile
            ? Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _buildVisual(),
                  const SizedBox(height: 30),
                  _buildDetails(),
                ],
              )
            : Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildVisual(),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    flex: 6,
                    child: _buildDetails(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildVisual() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.air_rounded,
              color: AppTheme.primaryLight,
              size: 60,
            ),
            SizedBox(height: 18),
            Text(
              'AIR GUARD',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'AQI • ML • HEALTH',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          '01 / FEATURED PROJECT',
          style: TextStyle(
            color: AppTheme.primaryLight,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(height: 14),

        Text(
          widget.project.title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          widget.project.description,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 16,
            height: 1.7,
          ),
        ),

        const SizedBox(height: 22),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.project.technologies
              .map(
                (technology) => _TechTag(technology),
              )
              .toList(),
        ),

        const SizedBox(height: 28),

        Wrap(
          spacing: 24,
          runSpacing: 12,
          children: [
            if (widget.project.projectUrl != null)
              _ProjectLink(
                label: 'View Project',
                icon: Icons.open_in_new_rounded,
                url: widget.project.projectUrl,
              ),

            if (widget.project.caseStudyUrl != null)
              _ProjectLink(
                label: 'Case Study',
                icon: Icons.arrow_forward_rounded,
                url: widget.project.caseStudyUrl,
              ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// PROJECT CARD
// ============================================================================

class _ProjectCard extends StatefulWidget {
  final Project? project;

  const _ProjectCard({
    required this.project,
  });

  @override
  State<_ProjectCard> createState() =>
      _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    if (project == null) {
      return const SizedBox.shrink();
    }

    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovered = true);
      },
      onExit: (_) {
        setState(() => isHovered = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: isHovered
              ? AppTheme.surfaceLight
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isHovered
                ? AppTheme.primary.withValues(alpha: 0.4)
                : AppTheme.border,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              '${project.order.toString().padLeft(2, '0')} / PROJECT',
              style: const TextStyle(
                color: AppTheme.primaryLight,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              project.title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              project.description,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.7,
              ),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: project.technologies
                  .map(
                    (technology) =>
                        _TechTag(technology),
                  )
                  .toList(),
            ),

            const SizedBox(height: 24),

            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                if (project.projectUrl != null)
                  _ProjectLink(
                    label: 'View Project',
                    icon: Icons.arrow_forward_rounded,
                    url: project.projectUrl,
                  ),

                if (project.caseStudyUrl != null)
                  _ProjectLink(
                    label: 'Case Study',
                    icon: Icons.open_in_new_rounded,
                    url: project.caseStudyUrl,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// TECHNOLOGY TAG
// ============================================================================

class _TechTag extends StatelessWidget {
  final String text;

  const _TechTag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius:
            BorderRadius.circular(7),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 11,
        ),
      ),
    );
  }
}

// ============================================================================
// PROJECT LINK
// ============================================================================

class _ProjectLink extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? url;

  const _ProjectLink({
    required this.label,
    required this.icon,
    this.url,
  });

  Future<void> _openLink() async {
    if (url == null || url!.isEmpty) {
      return;
    }

    final uri = Uri.tryParse(url!);

    if (uri == null) {
      return;
    }

    await launchUrl(
      uri,
      webOnlyWindowName: '_blank',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isClickable =
        url != null && url!.isNotEmpty;

    return MouseRegion(
      cursor: isClickable
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: isClickable
            ? _openLink
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isClickable
                    ? AppTheme.textPrimary
                    : AppTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(width: 6),

            Icon(
              icon,
              size: 15,
              color: isClickable
                  ? AppTheme.primaryLight
                  : AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// LOADING
// ============================================================================

class _ProjectsLoading extends StatelessWidget {
  const _ProjectsLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// ============================================================================
// ERROR
// ============================================================================

class _ProjectsError extends StatelessWidget {
  final String message;

  const _ProjectsError({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Unable to load projects.',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EMPTY
// ============================================================================

class _ProjectsEmpty extends StatelessWidget {
  const _ProjectsEmpty();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'No projects available.',
      style: TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 16,
      ),
    );
  }
}