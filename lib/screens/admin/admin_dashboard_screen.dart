import 'package:flutter/material.dart';

import 'admin_messages_screen.dart';
import 'admin_achievements_screen.dart';
import 'admin_education_screen.dart';
import 'admin_experience_screen.dart';
import 'admin_skills_screen.dart';
import '../../app/theme.dart';
import '../../services/auth_service.dart';
import 'admin_projects_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppTheme.surface,
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              AuthService.clearToken();

              Navigator.of(context).pushNamedAndRemoveUntil(
                '/admin',
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1100,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                final crossAxisCount = width < 600
                    ? 1
                    : width < 950
                        ? 2
                        : 3;

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: width < 600 ? 2.2 : 1.7,
                  children: [
                 _AdminCard(
  icon: Icons.work_outline_rounded,
  title: 'Projects',
  subtitle: 'Add, edit and manage projects',
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AdminProjectsScreen(),
      ),
    );
  },
),

_AdminCard(
  icon: Icons.code_rounded,
  title: 'Skills',
  subtitle: 'Manage technical skills',
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AdminSkillsScreen(),
      ),
    );
  },
),

_AdminCard(
  icon: Icons.business_center_outlined,
  title: 'Experience',
  subtitle: 'Manage work experience',
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AdminExperienceScreen(),
      ),
    );
  },
),

_AdminCard(
  icon: Icons.school_outlined,
  title: 'Education',
  subtitle: 'Manage academic records',
  onTap: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => const AdminEducationScreen(),
    ),
  );
},
),

_AdminCard(
  icon: Icons.emoji_events_outlined,
  title: 'Achievements',
  subtitle: 'Manage achievements',
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AdminAchievementsScreen(),
      ),
    );
  },
),

_AdminCard(
  icon: Icons.mail_outline_rounded,
  title: 'Messages',
  subtitle: 'View contact messages',
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AdminMessagesScreen(),
      ),
    );
  },
),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _AdminCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppTheme.border,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),

                Icon(
                  icon,
                  color: AppTheme.primaryLight,
                  size: 30,
                ),

                const SizedBox(height: 16),

                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}