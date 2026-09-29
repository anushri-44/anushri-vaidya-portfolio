import 'package:flutter/material.dart';
import 'package:my_portfolio/core/utils/scroll_manager.dart';

import '../../widgets/navbar/navbar.dart';
import '../../widgets/hero/hero_section.dart';
import '../../screens/about/about_section.dart';
import '../../screens/skills/skills_section.dart';
import '../../screens/experience/experience_section.dart';
import '../../screens/projects/projects_section.dart';
import '../../screens/achievements/achievements_section.dart';
import '../../screens/education/education_section.dart';
import '../../screens/contact/contact_section.dart';
import '../../widgets/footer/footer.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
  controller: ScrollManager.controller,
  child: Column(
          children: [
            const PortfolioNavbar(),
            const HeroSection(),
            const AboutSection(),
            const SkillsSection(),
            const ExperienceSection(),
            const ProjectsSection(),
            const AchievementsSection(),
            const EducationSection(),
            ContactSection(),
            const PortfolioFooter(),
          ],
        ),
      ),
    );
  }
}