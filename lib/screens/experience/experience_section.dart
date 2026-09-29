import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/experience.dart';
import '../../services/portfolio_api_service.dart';

class ExperienceSection extends StatelessWidget {
  static final GlobalKey sectionKey = GlobalKey();

  const ExperienceSection({super.key});

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
            'EXPERIENCE',
            style: TextStyle(
              color: AppTheme.primaryLight,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Where I’ve built and learned.',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: isMobile ? 32 : 44,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 50),

          FutureBuilder<List<Experience>>(
            future: PortfolioApiService.fetchExperience(),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const _ExperienceLoading();
              }

              if (snapshot.hasError) {
                return _ExperienceError(
                  message: snapshot.error.toString(),
                );
              }

              final experience = snapshot.data ?? [];

              if (experience.isEmpty) {
                return const _ExperienceEmpty();
              }

              final sortedExperience = [...experience]
                ..sort(
                  (a, b) => a.order.compareTo(b.order),
                );

              return Column(
                children: sortedExperience
                    .map(
                      (item) => _ExperienceCard(
                        experience: item,
                        isMobile: isMobile,
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
}

// ============================================================================
// EXPERIENCE CARD
// ============================================================================

class _ExperienceCard extends StatefulWidget {
  final Experience experience;
  final bool isMobile;

  const _ExperienceCard({
    required this.experience,
    required this.isMobile,
  });

  @override
  State<_ExperienceCard> createState() =>
      _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final experience = widget.experience;

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
        padding: EdgeInsets.all(
          widget.isMobile ? 24 : 36,
        ),
        decoration: BoxDecoration(
          color: isHovered
              ? AppTheme.surfaceLight
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isHovered
                ? AppTheme.primary.withValues(alpha: 0.4)
                : AppTheme.border,
          ),
        ),
        child: widget.isMobile
            ? _buildMobile(experience)
            : _buildDesktop(experience),
      ),
    );
  }

  Widget _buildDesktop(Experience experience) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimelineIndicator(),

        const SizedBox(width: 28),

        Expanded(
          child: _buildExperienceDetails(experience),
        ),

        const SizedBox(width: 40),

        Text(
          '${experience.startDate} — ${experience.endDate}',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMobile(Experience experience) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimelineIndicator(),

        const SizedBox(height: 24),

        _buildExperienceDetails(experience),

        const SizedBox(height: 24),

        Text(
          '${experience.startDate} — ${experience.endDate}',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineIndicator() {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(top: 7),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.35),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceDetails(
    Experience experience,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          experience.role,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 23,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          '${experience.company} • ${experience.location}',
          style: const TextStyle(
            color: AppTheme.primaryLight,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 20),

        if (experience.technologies.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: experience.technologies
                .map(
                  (technology) => _TechTag(
                    technology,
                  ),
                )
                .toList(),
          ),

        const SizedBox(height: 24),

        Text(
          experience.description,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 16,
            height: 1.7,
          ),
        ),

        const SizedBox(height: 20),

        ...experience.bullets.map(
          (bullet) => _ExperienceBullet(
            text: bullet,
          ),
        ),
      ],
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
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ============================================================================
// BULLET
// ============================================================================

class _ExperienceBullet extends StatelessWidget {
  final String text;

  const _ExperienceBullet({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(
              color: AppTheme.primaryLight,
              fontSize: 18,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LOADING
// ============================================================================

class _ExperienceLoading extends StatelessWidget {
  const _ExperienceLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
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

class _ExperienceError extends StatelessWidget {
  final String message;

  const _ExperienceError({
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Unable to load experience.',
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

class _ExperienceEmpty extends StatelessWidget {
  const _ExperienceEmpty();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'No experience available.',
      style: TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 16,
      ),
    );
  }
}