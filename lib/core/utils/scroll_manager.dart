import 'package:flutter/material.dart';

class ScrollManager {
  static final ScrollController controller = ScrollController();

  static void scrollTo(GlobalKey key) {
    final context = key.currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        alignment: 0.05,
      );
    }
  }
}