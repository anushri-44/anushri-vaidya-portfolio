import 'package:flutter/material.dart';
import 'package:my_portfolio/core/utils/scroll_manager.dart';
import 'package:my_portfolio/screens/projects/projects_section.dart';
import '../../app/theme.dart';
import '../../core/utils/launcher_service.dart';


class HeroSection extends StatelessWidget {
  static final GlobalKey sectionKey = GlobalKey();
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
  key: HeroSection.sectionKey,
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 650,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 70 : 100,
      ),
      child: isMobile
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: _buildContent(context),
        ),
        const SizedBox(width: 60),
        Expanded(
          flex: 4,
          child: _buildVisual(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContent(context),
        const SizedBox(height: 60),
        _buildVisual(),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Availability badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppTheme.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'OPEN TO SOFTWARE DEVELOPMENT OPPORTUNITIES',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Greeting
        Text(
          "Hi, I'm",
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: isMobile ? 28 : 38,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 4),

        // Name
        Text(
          'ANUSHRI VAIDYA',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: isMobile ? 42 : 68,
            fontWeight: FontWeight.w800,
            height: 1,
            letterSpacing: -2,
          ),
        ),

        const SizedBox(height: 24),

        // Main statement
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: isMobile ? 28 : 42,
              height: 1.15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            children: const [
              TextSpan(
                text: 'I build software that\n',
              ),
              TextSpan(
                text: 'solves real problems.',
                style: TextStyle(
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Description
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 650,
          ),
          child: const Text(
            'Computer Engineering student focused on Flutter, '
            'Java, Python and AI/ML, with hands-on experience '
            'building mobile, backend and intelligent applications.',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 17,
              height: 1.7,
            ),
          ),
        ),

        const SizedBox(height: 36),

        // Buttons
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            ElevatedButton.icon(
      onPressed: () {
        LauncherService.openHireMeEmail();
      },
      icon: const Icon(
        Icons.mail_outline_rounded,
        size: 18,
      ),
      label: const Text('Hire Me  ↗'),
    ),
            ElevatedButton(

             onPressed: () {
  ScrollManager.scrollTo(
    ProjectsSection.sectionKey,
  );
},
              child: const Text('Explore My Work  →'),
            ),

            OutlinedButton(
              onPressed: () {
                LauncherService.openResume();
                // Resume functionality will be added later.
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textPrimary,
                side: const BorderSide(
                  color: AppTheme.border,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Download Resume  ↓'),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Social links
        Row(
          children: [
            _socialLink('GitHub'),
            _divider(),
            _socialLink('LinkedIn'),
            _divider(),
            _socialLink('Email'),
          ],
        ),
      ],
    );
  }

  Widget _socialLink(String title) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () {
        switch (title) {
          case 'GitHub':
            LauncherService.openGitHub();
            break;

          case 'LinkedIn':
            LauncherService.openLinkedIn();
            break;

          case 'Email':
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
  );
}

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      width: 1,
      height: 14,
      color: AppTheme.border,
    );
  }

  Widget _buildVisual() {
    return Container(
      height: 420,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Stack(
        children: [
          // Decorative grid
          Positioned.fill(
            child: CustomPaint(
              painter: _GridPainter(),
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.code_rounded,
                  size: 64,
                  color: AppTheme.primary.withValues(alpha: 0.9),
                ),
                const SizedBox(height: 20),
                const Text(
                  'BUILD • LEARN • CREATE',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Flutter  •  Java  •  Python  •  AI/ML',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.border.withValues(alpha: 0.35)
      ..strokeWidth = 1;

    const spacing = 40.0;

    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}