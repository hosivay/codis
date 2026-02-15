import 'package:flutter/material.dart';

import 'package:codis/core/l10n/app_strings.dart';
import 'package:codis/core/theme/app_palette.dart';
import 'package:codis/features/cipher/presentation/widgets/cipher_text_field.dart';
import 'package:codis/features/cipher/presentation/widgets/primary_button.dart';
import 'package:codis/features/cipher/presentation/widgets/result_card.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.locale,
    required this.title,
    required this.subtitle,
    required this.inputHint,
    required this.inputController,
    required this.secretController,
    required this.actionLabel,
    required this.onAction,
    required this.isLoading,
    this.error,
    this.result,
    this.onCopy,
  });

  final Locale locale;
  final String title;
  final String subtitle;
  final String inputHint;
  final TextEditingController inputController;
  final TextEditingController secretController;
  final String actionLabel;
  final VoidCallback onAction;
  final bool isLoading;
  final String? error;
  final String? result;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final cardPadding = width < AppPalette.breakpointSmall ? 16.0 : 24.0;
    final textPrimary = isDark ? AppPalette.textPrimaryDark : AppPalette.textPrimaryLight;
    final textSecondary = isDark ? AppPalette.textSecondaryDark : AppPalette.textSecondaryLight;
    final errorColor = isDark ? AppPalette.errorDark : AppPalette.errorLight;
    final dir = AppStrings.textDirection(locale);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.surfaceElevatedDark : AppPalette.surfaceElevatedLight,
        borderRadius: BorderRadius.circular(AppPalette.radiusXl),
        border: Border.all(
          color: isDark ? AppPalette.borderDark : AppPalette.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            textDirection: dir,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
            textDirection: dir,
          ),
          const SizedBox(height: 20),
          CipherTextField(
            controller: inputController,
            hint: inputHint,
            minLines: 2,
            maxLines: 20,
            showPasteButton: true,
            textDirection: dir,
          ),
          const SizedBox(height: 14),
          CipherTextField(
            controller: secretController,
            hint: AppStrings.secretHint(locale),
            maxLines: 1,
            isSecret: true,
            showPasteButton: true,
            textDirection: dir,
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: actionLabel,
            isLoading: isLoading,
            onPressed: onAction,
          ),
          if (error != null && error!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              error!,
              style: TextStyle(color: errorColor, fontSize: 14, height: 1.4),
              textDirection: dir,
            ),
          ],
          if (result != null && result!.isNotEmpty) ...[
            const SizedBox(height: 18),
            ResultCard(
              locale: locale,
              result: result!,
              onCopy: onCopy ?? () {},
            ),
          ],
        ],
      ),
    );
  }
}
