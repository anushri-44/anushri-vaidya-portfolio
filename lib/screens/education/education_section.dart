import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../models/education.dart';
import '../../services/portfolio_api_service.dart';

class EducationSection extends StatefulWidget {
  static final GlobalKey sectionKey = GlobalKey();

  const EducationSection({super.key});

  @override
  State<EducationSection> createState() => _EducationSectionState();
}

class _EducationSectionState extends State<EducationSection> {
  late Future<List<Education>> _educationFuture;

  @override
  void initState() {
    super.initState();
    _educationFuture = PortfolioApiService().fetchEducation();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;

    return Container(
      key: EducationSection.sectionKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EDUCATION',
            style: TextStyle(
              color: AppTheme.primaryLight,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'My academic foundation.',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: isMobile ? 32 : 44,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 50),

          FutureBuilder<List<Education>>(
            future: _educationFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildStateMessage(
                  'Loading education...',
                  isMobile,
                );
              }

              if (snapshot.hasError) {
                return _buildStateMessage(
                  'Unable to load education.',
                  isMobile,
                );
              }

              final education = snapshot.data ?? [];

              if (education.isEmpty) {
                return _buildStateMessage(
                  'No education data available.',
                  isMobile,
                );
              }

              final item = education.first;

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
                child: isMobile
                    ? _buildMobile(item)
                    : _buildDesktop(item),
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

  Widget _buildDesktop(Education education) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIcon(),

        const SizedBox(width: 28),

        Expanded(
          child: _buildDetails(education),
        ),

        const SizedBox(width: 30),

        Text(
          '${education.startDate} — ${education.endDate}',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMobile(Education education) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIcon(),

        const SizedBox(height: 24),

        _buildDetails(education),

        const SizedBox(height: 20),

        Text(
          '${education.startDate} — ${education.endDate}',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: const Icon(
        Icons.school_outlined,
        color: AppTheme.primaryLight,
      ),
    );
  }

  Widget _buildDetails(Education education) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          education.degree,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 21,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          '${education.institution} • ${education.location}',
          style: const TextStyle(
            color: AppTheme.primaryLight,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 18),

        Text(
          education.status,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          education.description,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}