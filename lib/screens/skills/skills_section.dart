import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/skill.dart';
import '../../services/portfolio_api_service.dart';

class SkillsSection extends StatelessWidget {
  static final GlobalKey sectionKey = GlobalKey();

  const SkillsSection({super.key});

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
            'SKILLS',
            style: TextStyle(
              color: AppTheme.primaryLight,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Technologies I work with.',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: isMobile ? 32 : 44,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 50),

          FutureBuilder<List<Skill>>(
            future: PortfolioApiService.fetchSkills(),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const _SkillsLoading();
              }

              if (snapshot.hasError) {
                return _SkillsError(
                  message: snapshot.error.toString(),
                );
              }

              final skills = snapshot.data ?? [];

              if (skills.isEmpty) {
                return const _SkillsEmpty();
              }

              final sortedSkills = [...skills]
                ..sort(
                  (a, b) => a.order.compareTo(b.order),
                );

              if (isMobile) {
                return Column(
                  children: sortedSkills
                      .map(
                        (skill) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: _SkillCard(
                            icon: _getIcon(skill.icon),
                            title: skill.category,
                            skills: skill.skills,
                          ),
                        ),
                      )
                      .toList(),
                );
              }

              return GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.8,
                children: sortedSkills
                    .map(
                      (skill) => _SkillCard(
                        icon: _getIcon(skill.icon),
                        title: skill.category,
                        skills: skill.skills,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  static IconData _getIcon(String icon) {
    switch (icon) {
      case 'code':
        return Icons.code_rounded;

      case 'phone_android':
        return Icons.phone_android_rounded;

      case 'auto_awesome':
        return Icons.auto_awesome_rounded;

      case 'storage':
        return Icons.storage_rounded;

      default:
        return Icons.code_rounded;
    }
  }
}

class _SkillCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<String> skills;

  const _SkillCard({
    required this.icon,
    required this.title,
    required this.skills,
  });

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() => isHovered = true);
      },
      onExit: (_) {
        setState(() => isHovered = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: isHovered
              ? AppTheme.surfaceLight
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isHovered
                ? AppTheme.primary.withValues(
                    alpha: 0.5,
                  )
                : AppTheme.border,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Icon(
              widget.icon,
              color: AppTheme.primaryLight,
              size: 28,
            ),

            const SizedBox(height: 18),

            Text(
              widget.title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 14),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.skills.map(
                (skill) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
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
                      skill,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillsLoading extends StatelessWidget {
  const _SkillsLoading();

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

class _SkillsError extends StatelessWidget {
  final String message;

  const _SkillsError({
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
            'Unable to load skills.',
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

class _SkillsEmpty extends StatelessWidget {
  const _SkillsEmpty();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'No skills available.',
      style: TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 16,
      ),
    );
  }
}