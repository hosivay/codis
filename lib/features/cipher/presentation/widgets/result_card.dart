import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:Codis/core/l10n/app_strings.dart';
import 'package:Codis/core/theme/app_palette.dart';
import 'package:Codis/features/cipher/presentation/widgets/result_full_screen_page.dart';

class ResultCard extends StatefulWidget {
  const ResultCard({
    super.key,
    required this.locale,
    required this.result,
    required this.onCopy,
  });

  final Locale locale;
  final String result;
  final VoidCallback onCopy;

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: AppPalette.animNormal);
    _fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOut));
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  void _handleCopy() {
    Clipboard.setData(ClipboardData(text: widget.result));
    widget.onCopy();
    setState(() => _copied = true);
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  Future<void> _handleShare() async {
    await Share.share(widget.result);
  }

  void _openFullScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ResultFullScreenPage(
          locale: widget.locale,
          result: widget.result,
          onCopy: widget.onCopy,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < AppPalette.breakpointSmall;
    final surface = isDark ? AppPalette.surfaceElevatedDark : AppPalette.surfaceElevatedLight;
    final border = isDark ? AppPalette.borderDark : AppPalette.borderLight;
    final textPrimary = isDark ? AppPalette.textPrimaryDark : AppPalette.textPrimaryLight;
    final accent = isDark ? AppPalette.accentDark : AppPalette.accentLight;
    final success = isDark ? AppPalette.successDark : AppPalette.successLight;
    final btnPadding = compact ? 8.0 : 10.0;
    final iconSize = compact ? 16.0 : 18.0;
    final fontSize = compact ? 12.0 : 13.0;
    final dir = AppStrings.textDirection(widget.locale);

    Widget actionBtn({
      required VoidCallback onTap,
      required IconData icon,
      required String label,
      bool highlighted = false,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 12, vertical: btnPadding),
          decoration: BoxDecoration(
            color: highlighted ? success.withValues(alpha: 0.2) : accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppPalette.radiusSm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: iconSize, color: highlighted ? success : accent),
              if (!compact) ...[
                const SizedBox(width: 6),
                Text(
                  label,
                  textDirection: dir,
                  style: TextStyle(color: highlighted ? success : accent, fontSize: fontSize, fontWeight: FontWeight.w500),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(AppPalette.radiusLg),
            border: Border.all(color: border, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.resultLabel(widget.locale),
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: compact ? 14 : 15,
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: dir,
                    ),
                    Flexible(
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          actionBtn(
                            onTap: _handleCopy,
                            icon: _copied ? Icons.check_rounded : Icons.copy_rounded,
                            label: _copied ? AppStrings.copied(widget.locale) : AppStrings.copyResult(widget.locale),
                            highlighted: _copied,
                          ),
                          actionBtn(
                            onTap: _handleShare,
                            icon: Icons.share_rounded,
                            label: AppStrings.shareResult(widget.locale),
                          ),
                          actionBtn(
                            onTap: _openFullScreen,
                            icon: Icons.fullscreen_rounded,
                            label: AppStrings.viewFullScreen(widget.locale),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 360),
                  child: SingleChildScrollView(
                    child: Directionality(
                      textDirection: dir,
                      child: MarkdownBody(
                        data: widget.result,
                        shrinkWrap: true,
                        selectable: true,
                      onTapLink: (text, href, title) {
                        if (href != null && href.isNotEmpty) {
                          final uri = Uri.tryParse(href);
                          if (uri != null) {
                            launchUrl(uri, mode: LaunchMode.platformDefault);
                          }
                        }
                      },
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(color: textPrimary, fontSize: 15, height: 1.6),
                        h1: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w700),
                        h2: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
                        h3: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                        listBullet: TextStyle(color: textPrimary, fontSize: 15),
                        blockquote: TextStyle(color: textPrimary, fontSize: 15, fontStyle: FontStyle.italic),
                        blockquoteDecoration: BoxDecoration(
                          border: Border(
                            left: dir == TextDirection.ltr ? BorderSide(color: accent, width: 3) : BorderSide.none,
                            right: dir == TextDirection.rtl ? BorderSide(color: accent, width: 3) : BorderSide.none,
                          ),
                        ),
                        a: TextStyle(color: accent, fontSize: 15, decoration: TextDecoration.underline),
                        code: TextStyle(
                          color: textPrimary,
                          fontSize: 14,
                          backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(AppPalette.radiusSm),
                        ),
                      ),
                    ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
