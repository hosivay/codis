import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:Codis/core/l10n/app_strings.dart';
import 'package:Codis/core/theme/app_palette.dart';

class ResultFullScreenPage extends StatefulWidget {
  const ResultFullScreenPage({
    super.key,
    required this.locale,
    required this.result,
    this.onCopy,
  });

  final Locale locale;
  final String result;
  final VoidCallback? onCopy;

  @override
  State<ResultFullScreenPage> createState() => _ResultFullScreenPageState();
}

class _ResultFullScreenPageState extends State<ResultFullScreenPage> {
  bool _copied = false;

  void _handleCopy() {
    Clipboard.setData(ClipboardData(text: widget.result));
    widget.onCopy?.call();
    setState(() => _copied = true);
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  Future<void> _handleShare() async {
    await Share.share(widget.result);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final padding = width < AppPalette.breakpointSmall ? 16.0 : 24.0;
    final textPrimary = isDark ? AppPalette.textPrimaryDark : AppPalette.textPrimaryLight;
    final accent = isDark ? AppPalette.accentDark : AppPalette.accentLight;
    final dir = AppStrings.textDirection(widget.locale);

    return Directionality(
      textDirection: dir,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            AppStrings.resultLabel(widget.locale),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: width < AppPalette.breakpointSmall ? 18 : 20,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(_copied ? Icons.check_rounded : Icons.copy_rounded),
              onPressed: _handleCopy,
              tooltip: AppStrings.copyResult(widget.locale),
            ),
            IconButton(
              icon: const Icon(Icons.share_rounded),
              onPressed: _handleShare,
              tooltip: AppStrings.shareResult(widget.locale),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
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
                  p: TextStyle(color: textPrimary, fontSize: 16, height: 1.6),
                  h1: TextStyle(color: textPrimary, fontSize: 22, fontWeight: FontWeight.w700),
                  h2: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
                  h3: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
                  listBullet: TextStyle(color: textPrimary, fontSize: 16),
                  blockquote: TextStyle(color: textPrimary, fontSize: 16, fontStyle: FontStyle.italic),
                  blockquoteDecoration: BoxDecoration(
                    border: Border(
                      left: dir == TextDirection.ltr ? BorderSide(color: accent, width: 3) : BorderSide.none,
                      right: dir == TextDirection.rtl ? BorderSide(color: accent, width: 3) : BorderSide.none,
                    ),
                  ),
                  a: TextStyle(color: accent, fontSize: 16, decoration: TextDecoration.underline),
                  code: TextStyle(
                    color: textPrimary,
                    fontSize: 15,
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
      ),
    );
  }
}
