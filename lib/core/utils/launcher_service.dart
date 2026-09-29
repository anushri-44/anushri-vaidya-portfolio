import 'package:url_launcher/url_launcher.dart';

import '../constants/portfolio_constants.dart';

class LauncherService {
  static Future<void> openHireMeEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: PortfolioConstants.email,
      queryParameters: {
        'subject': PortfolioConstants.hireMeSubject,
        'body': PortfolioConstants.hireMeBody,
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }
static Future<void> openGitHub() async {
    final Uri url = Uri.parse(
      PortfolioConstants.githubUrl,
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  static Future<void> openLinkedIn() async {
    final Uri url = Uri.parse(
      PortfolioConstants.linkedinUrl,
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  static Future<void> openResume() async {
    final Uri url = Uri.parse(
      PortfolioConstants.resumeUrl,
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

}