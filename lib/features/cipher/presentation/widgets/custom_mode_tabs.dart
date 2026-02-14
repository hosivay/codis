import 'package:flutter/material.dart';

import 'package:codis/core/theme/app_palette.dart';

class CustomModeTabs extends StatelessWidget {
  const CustomModeTabs({
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
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final surface = isDark ? AppPalette.surfaceElevatedDark : AppPalette.surfaceElevatedLight;
    final border = isDark ? AppPalette.borderDark : AppPalette.borderLight;
    final textSecondary = isDark ? AppPalette.textSecondaryDark : AppPalette.textSecondaryLight;
    final accent = isDark ? AppPalette.accentDark : AppPalette.accentLight;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppPalette.radiusLg),
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segmentWidth = (constraints.maxWidth - 12) / labels.length;
          final pillLeft = isRtl
              ? 6 + (labels.length - 1 - selectedIndex) * segmentWidth
              : 6 + selectedIndex * segmentWidth;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: AppPalette.animNormal,
                curve: Curves.easeOutCubic,
                left: pillLeft,
                top: 6,
                bottom: 6,
                child: Container(
                  width: segmentWidth - 6,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppPalette.radiusMd),
                    border: Border.all(color: accent, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: List.generate(labels.length, (i) {
                  final selected = i == selectedIndex;
                  return Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => onChanged(i),
                        borderRadius: BorderRadius.circular(AppPalette.radiusMd),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: AppPalette.animFast,
                              style: TextStyle(
                                color: selected ? accent : textSecondary,
                                fontSize: 15,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              ),
                              child: Text(
                                labels[i],
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
