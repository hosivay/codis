import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';

import 'package:codis/core/theme/app_palette.dart';

class AnimatedActionCard extends StatefulWidget {
  const AnimatedActionCard({
    super.key,
    required this.delayFrames,
    required this.child,
  });

  final int delayFrames;
  final Widget child;

  @override
  State<AnimatedActionCard> createState() => _AnimatedActionCardState();
}

class _AnimatedActionCardState extends State<AnimatedActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  void _scheduleForward() {
    if (widget.delayFrames <= 0) {
      if (mounted) _ac.forward();
      return;
    }
    void runAfterFrames(int remaining) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (remaining <= 1) {
          _ac.forward();
        } else {
          runAfterFrames(remaining - 1);
        }
      });
    }
    runAfterFrames(widget.delayFrames);
  }

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: AppPalette.animSlow,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));
    _scheduleForward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}
