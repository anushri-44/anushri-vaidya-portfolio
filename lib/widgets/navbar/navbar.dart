import 'package:flutter/material.dart';

import 'package:my_portfolio/app/theme.dart';
import 'package:my_portfolio/widgets/hero/hero_section.dart';
import 'package:my_portfolio/screens/about/about_section.dart';
import 'package:my_portfolio/screens/skills/skills_section.dart';
import 'package:my_portfolio/screens/experience/experience_section.dart';
import 'package:my_portfolio/screens/projects/projects_section.dart';
import 'package:my_portfolio/screens/achievements/achievements_section.dart';
import 'package:my_portfolio/screens/education/education_section.dart';
import 'package:my_portfolio/screens/contact/contact_section.dart';

import '../../core/utils/scroll_manager.dart';
import '../../core/utils/launcher_service.dart';

class PortfolioNavbar extends StatelessWidget {
  const PortfolioNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 60,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: AppTheme.background.withValues(alpha: 0.92),
        border: const Border(
          bottom: BorderSide(
            color: AppTheme.border,
            width: 1,
          ),
        ),
      ),
      child: isMobile
          ? _buildMobileNavbar(context)
          : _buildDesktopNavbar(context),
    );
  }

  Widget _buildDesktopNavbar(BuildContext context) {
    return Row(
      children: [
        _buildLogo(),
        const Spacer(),

        _buildNavItem('Home'),
        _buildNavItem('About'),
        _buildNavItem('Skills'),
        _buildNavItem('Experience'),
        _buildNavItem('Projects'),
        _buildNavItem('Achievements'),
        _buildNavItem('Contact'),
        _buildNavItem('Hire Me'),

        const SizedBox(width: 28),

        _buildResumeButton(),
      ],
    );
  }

  Widget _buildMobileNavbar(BuildContext context) {
    return Row(
      children: [
        _buildLogo(),
        const Spacer(),

        IconButton(
          onPressed: () {
            _showMobileMenu(context);
          },
          icon: const Icon(
            Icons.menu_rounded,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return const Text(
      'AV /',
      style: TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
    );
  }

Widget _buildNavItem(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          switch (title) {
            case 'Home':
              ScrollManager.scrollTo(
                HeroSection.sectionKey,
              );
              break;

            case 'About':
              ScrollManager.scrollTo(
                AboutSection.sectionKey,
              );
              break;

            case 'Skills':
              ScrollManager.scrollTo(
                SkillsSection.sectionKey,
              );
              break;

            case 'Experience':
              ScrollManager.scrollTo(
                ExperienceSection.sectionKey,
              );
              break;

            case 'Projects':
              ScrollManager.scrollTo(
                ProjectsSection.sectionKey,
              );
              break;

            case 'Achievements':
              ScrollManager.scrollTo(
                AchievementsSection.sectionKey,
              );
              break;

            case 'Education':
              ScrollManager.scrollTo(
                EducationSection.sectionKey,
              );
              break;

            case 'Contact':
              ScrollManager.scrollTo(
                ContactSection.sectionKey,
              );
              break;

            case 'Hire Me':
              LauncherService.openHireMeEmail();
              break;
          }
        },
        child: Text(
          title,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
  );
}

  Widget _buildResumeButton() {
  return ElevatedButton(
    onPressed: () {
      LauncherService.openResume();
    },
    child: const Text('Resume ↗'),
  );
}

void _showMobileMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppTheme.surface,
    isScrollControlled: true,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _mobileMenuItem(context, 'Home'),
                _mobileMenuItem(context, 'About'),
                _mobileMenuItem(context, 'Skills'),
                _mobileMenuItem(context, 'Experience'),
                _mobileMenuItem(context, 'Projects'),
                _mobileMenuItem(context, 'Achievements'),
                _mobileMenuItem(context, 'Education'),
                _mobileMenuItem(context, 'Contact'),
                _mobileMenuItem(context, 'Hire Me'),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _mobileMenuItem(BuildContext context, String title) {
  return ListTile(
    title: Text(
      title,
      style: const TextStyle(
        color: AppTheme.textPrimary,
      ),
    ),
    onTap: () {
      Navigator.pop(context);

      switch (title) {
        case 'Home':
          ScrollManager.scrollTo(
            HeroSection.sectionKey,
          );
          break;

        case 'About':
          ScrollManager.scrollTo(
            AboutSection.sectionKey,
          );
          break;

        case 'Skills':
          ScrollManager.scrollTo(
            SkillsSection.sectionKey,
          );
          break;

        case 'Experience':
          ScrollManager.scrollTo(
            ExperienceSection.sectionKey,
          );
          break;

        case 'Projects':
          ScrollManager.scrollTo(
            ProjectsSection.sectionKey,
          );
          break;

        case 'Achievements':
          ScrollManager.scrollTo(
            AchievementsSection.sectionKey,
          );
          break;

        case 'Education':
          ScrollManager.scrollTo(
            EducationSection.sectionKey,
          );
          break;

        case 'Contact':
          ScrollManager.scrollTo(
            ContactSection.sectionKey,
          );
          break;

        case 'Hire Me':
          LauncherService.openHireMeEmail();
          break;
      }
    },
  );
}
}