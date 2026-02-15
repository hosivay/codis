import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:codis/core/theme/app_palette.dart';

class CipherTextField extends StatefulWidget {
  const CipherTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.minLines,
    this.maxLines = 5,
    this.obscureText = false,
    this.isSecret = false,
    this.textDirection,
    this.showPasteButton = false,
  });

  final TextEditingController controller;
  final String hint;
  final int? minLines;
  final int maxLines;
  final bool obscureText;
  final bool isSecret;
  final TextDirection? textDirection;
  final bool showPasteButton;

  @override
  State<CipherTextField> createState() => _CipherTextFieldState();
}

class _CipherTextFieldState extends State<CipherTextField> with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _ac;
  late Animation<double> _scale;
  bool _obscured = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _ac = AnimationController(vsync: this, duration: AppPalette.animFast);
    _scale = Tween<double>(begin: 1, end: 0.98).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOut));
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _ac.forward();
      } else {
        _ac.reverse();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppPalette.surfaceElevatedDark : AppPalette.surfaceElevatedLight;
    final border = isDark ? AppPalette.borderDark : AppPalette.borderLight;
    final textColor = isDark ? AppPalette.textPrimaryDark : AppPalette.textPrimaryLight;
    final hintColor = isDark ? AppPalette.textSecondaryDark : AppPalette.textSecondaryLight;

    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppPalette.radiusMd),
              border: Border.all(color: border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppPalette.radiusMd),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                obscureText: widget.isSecret ? _obscured : widget.obscureText,
                textDirection: widget.textDirection ?? TextDirection.rtl,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyle(color: hintColor, fontSize: 16),
                  hintTextDirection: widget.textDirection ?? TextDirection.rtl,
                  contentPadding: EdgeInsets.fromLTRB(
                    widget.isSecret ? 48 : (widget.showPasteButton ? 48 : 18),
                    16,
                    widget.showPasteButton ? 48 : 18,
                    16,
                  ),
                  border: InputBorder.none,
                  prefixIcon: widget.showPasteButton
                      ? GestureDetector(
                          onTap: () async {
                            final data = await Clipboard.getData(Clipboard.kTextPlain);
                            if (data?.text != null && data!.text!.isNotEmpty) {
                              widget.controller.text = data.text!;
                            }
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(Icons.content_paste_rounded, size: 22, color: hintColor),
                          ),
                        )
                      : null,
                  suffixIcon: widget.isSecret
                      ? GestureDetector(
                          onTap: () => setState(() => _obscured = !_obscured),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Icon(
                              _obscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                              size: 22,
                              color: hintColor,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
