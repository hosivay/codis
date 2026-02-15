import 'package:flutter/material.dart';

import 'package:Codis/core/theme/app_palette.dart';

class SegmentTabs extends StatelessWidget {
  const SegmentTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppPalette.surfaceElevatedDark : AppPalette.surfaceElevatedLight;
    final border = isDark ? AppPalette.borderDark : AppPalette.borderLight;
    final textSecondary = isDark ? AppPalette.textSecondaryDark : AppPalette.textSecondaryLight;
    final accent = isDark ? AppPalette.accentDark : AppPalette.accentLight;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 48,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(AppPalette.radiusMd),
            border: Border.all(color: border, width: 1),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: AppPalette.animNormal,
                curve: Curves.easeOutCubic,
                left: 6 + (selectedIndex * (constraints.maxWidth - 12) / labels.length),
                top: 6,
                child: Container(
                  width: (constraints.maxWidth - 12) / labels.length - 6,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(AppPalette.radiusSm),
                  ),
                ),
              ),
              Row(
                children: List.generate(labels.length, (i) {
                  final selected = i == selectedIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(i),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: AppPalette.animFast,
                          style: TextStyle(
                            color: selected ? accent : textSecondary,
                            fontSize: 15,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                          ),
                          child: Text(
                            labels[i],
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
