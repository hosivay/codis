import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:codis/core/l10n/app_strings.dart';
import 'package:codis/core/theme/app_palette.dart';

class VersionFooter extends StatelessWidget {
  const VersionFooter({super.key, required this.locale});

  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark ? AppPalette.textSecondaryDark : AppPalette.textSecondaryLight;
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < AppPalette.breakpointSmall;
    final dir = AppStrings.textDirection(locale);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, isCompact ? 8 : 12, 16, isCompact ? 12 : 16),
        child: Center(
          child: FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.data?.version ?? '1.0.0';
              final label = '${AppStrings.versionLabel(locale)} $version';
              return Text(
                label,
                style: TextStyle(
                  color: textSecondary.withValues(alpha: 0.9),
                  fontSize: isCompact ? 12 : 13,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: dir,
              );
            },
          ),
        ),
      ),
    );
  }
}
