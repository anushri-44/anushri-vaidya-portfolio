import 'package:flutter/material.dart';

import '../../app/theme.dart';

import '../../core/utils/launcher_service.dart';

class PortfolioFooter extends StatelessWidget {
  const PortfolioFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 32,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.border,
          ),
        ),
      ),
      child: isMobile
          ? _buildMobileFooter()
          : _buildDesktopFooter(),
    );
  }

  Widget _buildDesktopFooter() {
    return Row(
      children: [
        _buildBrand(),
        const Spacer(),
        _buildLinks(),
        const SizedBox(width: 32),
        _buildCopyright(),
      ],
    );
  }

  Widget _buildMobileFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBrand(),
        const SizedBox(height: 24),
        _buildLinks(),
        const SizedBox(height: 24),
        _buildCopyright(),
      ],
    );
  }

  Widget _buildBrand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AV /',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Built with Flutter + Dart',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildLinks() {
    return Wrap(
      spacing: 20,
      runSpacing: 12,
      children: [
        _footerLink(
  'GitHub',
  () {
    LauncherService.openGitHub();
  },
),
_footerLink(
  'LinkedIn',
  () {
    LauncherService.openLinkedIn();
  },
),
        _footerLink(
          'Email',
          () {
            LauncherService.openHireMeEmail();
          },
        ),
      ],
    );
  }

  Widget _footerLink(String title, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCopyright() {
    return const Text(
      '© 2026 Anushri Vaidya',
      style: TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 12,
      ),
    );
  }
}