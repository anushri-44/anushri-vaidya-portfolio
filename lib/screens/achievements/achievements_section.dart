import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/achievement.dart';
import '../../services/portfolio_api_service.dart';

class AchievementsSection extends StatefulWidget {
  static final GlobalKey sectionKey = GlobalKey();

  const AchievementsSection({super.key});

  @override
  State<AchievementsSection> createState() => _AchievementsSectionState();
}

class _AchievementsSectionState extends State<AchievementsSection> {
  late Future<List<Achievement>> _achievementsFuture;

  @override
  void initState() {
    super.initState();
    _achievementsFuture = PortfolioApiService().fetchAchievements();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      key: AchievementsSection.sectionKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ACHIEVEMENTS & OPEN SOURCE',
            style: TextStyle(
              color: AppTheme.primaryLight,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Beyond the classroom.',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: isMobile ? 32 : 44,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 50),

          FutureBuilder<List<Achievement>>(
            future: _achievementsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildStateMessage(
                  'Loading achievements...',
                  isMobile,
                );
              }

              if (snapshot.hasError) {
                return _buildStateMessage(
                  'Unable to load achievements.',
                  isMobile,
                );
              }

              final achievements = snapshot.data ?? [];

              if (achievements.isEmpty) {
                return _buildStateMessage(
                  'No achievements available.',
                  isMobile,
                );
              }

              return isMobile
                  ? Column(
                      children: _buildMobileCards(achievements),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildDesktopCards(achievements),
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStateMessage(String message, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 36),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            message,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMobileCards(List<Achievement> achievements) {
    final cards = <Widget>[];

    for (int i = 0; i < achievements.length; i++) {
      cards.add(
        _AchievementCard(
          achievement: achievements[i],
        ),
      );

      if (i < achievements.length - 1) {
        cards.add(const SizedBox(height: 20));
      }
    }

    return cards;
  }

  List<Widget> _buildDesktopCards(List<Achievement> achievements) {
    final cards = <Widget>[];

    for (int i = 0; i < achievements.length; i++) {
      cards.add(
        Expanded(
          child: _AchievementCard(
            achievement: achievements[i],
          ),
        ),
      );

      if (i < achievements.length - 1) {
        cards.add(const SizedBox(width: 20));
      }
    }

    return cards;
  }
}

class _AchievementCard extends StatefulWidget {
  final Achievement achievement;

  const _AchievementCard({
    required this.achievement,
  });

  @override
  State<_AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<_AchievementCard> {
  bool isHovered = false;

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'code':
        return Icons.code_rounded;

      case 'emoji_events':
        return Icons.emoji_events_outlined;

      case 'school':
        return Icons.school_outlined;

      default:
        return Icons.star_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
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
                ? AppTheme.primary.withValues(alpha: 0.45)
                : AppTheme.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              _getIcon(widget.achievement.icon),
              color: AppTheme.primaryLight,
              size: 30,
            ),

            const SizedBox(height: 22),

            Text(
              widget.achievement.title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.achievement.subtitle,
              style: const TextStyle(
                color: AppTheme.primaryLight,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              widget.achievement.description,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}