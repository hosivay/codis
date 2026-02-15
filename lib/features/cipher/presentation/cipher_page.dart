import 'package:flutter/material.dart';

import 'package:codis/core/l10n/app_strings.dart';
import 'package:codis/core/theme/app_palette.dart';
import 'package:codis/features/cipher/presentation/cipher_viewmodel.dart';
import 'package:codis/features/cipher/presentation/widgets/action_card.dart';
import 'package:codis/features/cipher/presentation/widgets/animated_action_card.dart';
import 'package:codis/features/cipher/presentation/widgets/codis_header.dart';
import 'package:codis/features/cipher/presentation/widgets/custom_mode_tabs.dart';
import 'package:codis/features/cipher/presentation/widgets/version_footer.dart';

class CipherPage extends StatefulWidget {
  const CipherPage({
    super.key,
    this.onThemeToggle,
    this.onLocaleToggle,
    required this.locale,
  });

  final VoidCallback? onThemeToggle;
  final VoidCallback? onLocaleToggle;
  final Locale locale;

  @override
  State<CipherPage> createState() => _CipherPageState();
}

class _CipherPageState extends State<CipherPage> {
  final CipherViewModel _viewModel = CipherViewModel();
  final TextEditingController _encryptInputController = TextEditingController();
  final TextEditingController _encryptSecretController = TextEditingController();
  final TextEditingController _decryptInputController = TextEditingController();
  final TextEditingController _decryptSecretController = TextEditingController();
  int _mobileTabIndex = 0;

  @override
  void dispose() {
    _encryptInputController.dispose();
    _encryptSecretController.dispose();
    _decryptInputController.dispose();
    _decryptSecretController.dispose();
    super.dispose();
  }

  void _encrypt() {
    _viewModel.encrypt(
      _encryptInputController.text,
      _encryptSecretController.text,
      widget.locale,
      () => setState(() {}),
    );
  }

  void _decrypt() {
    _viewModel.decrypt(
      _decryptInputController.text,
      _decryptSecretController.text,
      widget.locale,
      () => setState(() {}),
    );
  }

  bool _isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= AppPalette.breakpointTablet;
  }

  double _contentPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < AppPalette.breakpointSmall) return 16;
    if (w < AppPalette.breakpointTablet) return 20;
    return 24;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktop(context);
    final dir = AppStrings.textDirection(widget.locale);

    return Directionality(
      textDirection: dir,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context),
              ),
              VersionFooter(locale: widget.locale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final padding = _contentPadding(context);
    final locale = widget.locale;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CodisHeader(
          locale: locale,
          onThemeToggle: widget.onThemeToggle,
          onLocaleToggle: widget.onLocaleToggle,
        ),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppPalette.desktopMaxContentWidth,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 12, top: 8),
                        child: AnimatedActionCard(
                          delayFrames: 0,
                          child: ActionCard(
                            locale: locale,
                            title: AppStrings.encryptTitle(locale),
                            subtitle: AppStrings.encryptSubtitle(locale),
                            inputHint: AppStrings.inputHintEncrypt(locale),
                            inputController: _encryptInputController,
                            secretController: _encryptSecretController,
                            actionLabel: AppStrings.doEncrypt(locale),
                            onAction: _encrypt,
                            isLoading: _viewModel.encryptLoading,
                            error: _viewModel.encryptError,
                            result: _viewModel.encryptResult,
                            onCopy: () => _showCopied(context),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: padding),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(right: 12, top: 8),
                        child: AnimatedActionCard(
                          delayFrames: 2,
                          child: ActionCard(
                            locale: locale,
                            title: AppStrings.decryptTitle(locale),
                            subtitle: AppStrings.decryptSubtitle(locale),
                            inputHint: AppStrings.inputHintDecrypt(locale),
                            inputController: _decryptInputController,
                            secretController: _decryptSecretController,
                            actionLabel: AppStrings.doDecrypt(locale),
                            onAction: _decrypt,
                            isLoading: _viewModel.decryptLoading,
                            error: _viewModel.decryptError,
                            result: _viewModel.decryptResult,
                            onCopy: () => _showCopied(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final padding = _contentPadding(context);
    final locale = widget.locale;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: CodisHeader(
            locale: locale,
            onThemeToggle: widget.onThemeToggle,
            onLocaleToggle: widget.onLocaleToggle,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(padding, 8, padding, 20),
            child: CustomModeTabs(
              labels: [AppStrings.encryptTitle(locale), AppStrings.decryptTitle(locale)],
              selectedIndex: _mobileTabIndex,
              onChanged: (i) => setState(() => _mobileTabIndex = i),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          sliver: SliverToBoxAdapter(
            child: AnimatedSwitcher(
              duration: AppPalette.animNormal,
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.04),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _mobileTabIndex == 0
                  ? _mobileEncryptCard()
                  : _mobileDecryptCard(),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _mobileEncryptCard() {
    final locale = widget.locale;
    return AnimatedActionCard(
      key: const ValueKey('mobile_encrypt'),
      delayFrames: 0,
      child: ActionCard(
        locale: locale,
        title: AppStrings.encryptTitle(locale),
        subtitle: AppStrings.encryptSubtitle(locale),
        inputHint: AppStrings.inputHintEncrypt(locale),
        inputController: _encryptInputController,
        secretController: _encryptSecretController,
        actionLabel: AppStrings.doEncrypt(locale),
        onAction: _encrypt,
        isLoading: _viewModel.encryptLoading,
        error: _viewModel.encryptError,
        result: _viewModel.encryptResult,
        onCopy: () => _showCopied(context),
      ),
    );
  }

  Widget _mobileDecryptCard() {
    final locale = widget.locale;
    return AnimatedActionCard(
      key: const ValueKey('mobile_decrypt'),
      delayFrames: 0,
      child: ActionCard(
        locale: locale,
        title: AppStrings.decryptTitle(locale),
        subtitle: AppStrings.decryptSubtitle(locale),
        inputHint: AppStrings.inputHintDecrypt(locale),
        inputController: _decryptInputController,
        secretController: _decryptSecretController,
        actionLabel: AppStrings.doDecrypt(locale),
        onAction: _decrypt,
        isLoading: _viewModel.decryptLoading,
        error: _viewModel.decryptError,
        result: _viewModel.decryptResult,
        onCopy: () => _showCopied(context),
      ),
    );
  }

  void _showCopied(BuildContext context) {
    final dir = AppStrings.textDirection(widget.locale);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.copied(widget.locale), textDirection: dir),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
