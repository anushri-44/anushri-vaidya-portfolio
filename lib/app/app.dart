import 'package:flutter/material.dart';
import 'package:my_portfolio/screens/admin/admin_login_screen.dart';

import 'package:my_portfolio/screens/home/home_screen.dart';

import 'theme.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anushri Vaidya | Software Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,

      home: const HomeScreen(),

      routes: {
        '/admin': (context) => const AdminLoginScreen(),
      },
    );
  }
}