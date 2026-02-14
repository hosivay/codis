import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:codis/core/constants/app_constants.dart';
import 'package:codis/core/theme/app_palette.dart';

class CodisHeader extends StatelessWidget {
  const CodisHeader({super.key, this.onThemeToggle});

  final VoidCallback? onThemeToggle;

  static const String _githubUrl = 'https://github.com/hosivay/codis';

  Future<void> _openGithub() async {
    final uri = Uri.parse(_githubUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < AppPalette.breakpointSmall;
    final isNarrow = width < AppPalette.breakpointTablet;
    final padding = isCompact ? 16.0 : (isNarrow ? 20.0 : 28.0);
    final titleSize = isCompact ? 24.0 : (isNarrow ? 28.0 : 32.0);
    final taglineSize = isCompact ? 13.0 : 16.0;
    final iconSize = isCompact ? 18.0 : 22.0;
    final iconPadding = isCompact ? 8.0 : 10.0;
    final verticalPadding = isCompact ? 20.0 : 28.0;

    final textPrimary = isDark ? AppPalette.textPrimaryDark : AppPalette.textPrimaryLight;
    final textSecondary = isDark ? AppPalette.textSecondaryDark : AppPalette.textSecondaryLight;
    final accent = isDark ? AppPalette.accentDark : AppPalette.accentLight;

    Widget _iconButton({required VoidCallback onTap, required Widget icon}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(iconPadding),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppPalette.radiusMd),
            border: Border.all(
              color: accent.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: icon,
        ),
      );
    }

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(padding, verticalPadding, padding, verticalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppConstants.appName,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: titleSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(height: isCompact ? 4 : 8),
                      Text(
                        AppConstants.tagline,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: taglineSize,
                          height: 1.45,
                          fontWeight: FontWeight.w400,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _iconButton(
                      onTap: _openGithub,
                      icon: FaIcon(FontAwesomeIcons.github, size: iconSize, color: accent),
                    ),
                    if (onThemeToggle != null) ...[
                      SizedBox(width: isCompact ? 8 : 12),
                      _iconButton(
                        onTap: onThemeToggle!,
                        icon: Icon(
                          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                          size: iconSize,
                          color: accent,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
