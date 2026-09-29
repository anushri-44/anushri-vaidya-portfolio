import 'package:flutter/material.dart';
import '../../core/utils/scroll_manager.dart';

class RevealOnScroll extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;

  const RevealOnScroll({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
    this.offset = 0.08,
  });

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.offset),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    ScrollManager.controller.addListener(_checkVisibility);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (_hasAnimated || !mounted) return;

    final renderObject = context.findRenderObject();

    if (renderObject is RenderBox && renderObject.hasSize) {
      final position = renderObject.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;

      final isVisible =
          position.dy < screenHeight * 0.9 &&
          position.dy + renderObject.size.height > 0;

      if (isVisible) {
        _hasAnimated = true;
        _controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    ScrollManager.controller.removeListener(_checkVisibility);
    _controller.dispose();
    super.dispose();
  }
}