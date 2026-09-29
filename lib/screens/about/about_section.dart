import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../widgets/animations/reveal_on_scroll.dart';

class AboutSection extends StatelessWidget {
  static final GlobalKey sectionKey = GlobalKey();

  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return RevealOnScroll(
      child: Container(
        key: AboutSection.sectionKey,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 80,
          vertical: 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel(),
            const SizedBox(height: 16),

            Text(
              'Building with purpose. Learning constantly.',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: isMobile ? 32 : 44,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),

            const SizedBox(height: 50),

            isMobile
                ? Column(
                    children: [
                      _buildAboutText(),
                      const SizedBox(height: 40),
                      _buildStats(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: _buildAboutText(),
                      ),
                      const SizedBox(width: 80),
                      Expanded(
                        flex: 4,
                        child: _buildStats(),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel() {
    return const Text(
      'ABOUT ME',
      style: TextStyle(
        color: AppTheme.primaryLight,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildAboutText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "I'm a Computer Engineering student who enjoys turning ideas "
          "into practical software solutions.",
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 21,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
        ),

        SizedBox(height: 22),

        Text(
          "My development journey has taken me across mobile development, "
          "backend systems and AI/ML. I primarily work with Flutter, Java "
          "and Python, and enjoy understanding how different parts of a "
          "software system work together.",
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 16,
            height: 1.8,
          ),
        ),

        SizedBox(height: 18),

        Text(
          "Through academic projects, internships and open-source "
          "contributions, I'm continuously improving my problem-solving "
          "and software development skills.",
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 16,
            height: 1.8,
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                value: '10+',
                label: 'Projects / Builds',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatCard(
                value: '1',
                label: 'Internship',
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _StatCard(
                value: '4',
                label: 'Core Languages',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatCard(
                value: '2027',
                label: 'Graduation',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
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
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.primaryLight,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}