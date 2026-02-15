import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Codis/core/l10n/app_strings.dart';
import 'package:Codis/core/theme/app_palette.dart';
import 'package:Codis/core/providers/app_providers.dart';
import 'package:Codis/features/cipher/presentation/widgets/action_card.dart';
import 'package:Codis/features/cipher/presentation/widgets/animated_action_card.dart';
import 'package:Codis/features/cipher/presentation/widgets/codis_header.dart';
import 'package:Codis/features/cipher/presentation/widgets/custom_mode_tabs.dart';
import 'package:Codis/features/cipher/presentation/cipher_viewmodel.dart';
import 'package:Codis/features/cipher/presentation/widgets/version_footer.dart';

class CipherPage extends ConsumerStatefulWidget {
  const CipherPage({super.key});

  @override
  ConsumerState<CipherPage> createState() => _CipherPageState();
}

class _CipherPageState extends ConsumerState<CipherPage> {
  final TextEditingController _encryptInputController = TextEditingController();
  final TextEditingController _encryptSecretController = TextEditingController();
  final TextEditingController _decryptInputController = TextEditingController();
  final TextEditingController _decryptSecretController = TextEditingController();
  int _mobileTabIndex = 0;
  bool _hideInTextEncrypt = false;
  bool _shortOutputEncrypt = false;

  @override
  void dispose() {
    _encryptInputController.dispose();
    _encryptSecretController.dispose();
    _decryptInputController.dispose();
    _decryptSecretController.dispose();
    super.dispose();
  }

  void _encrypt() {
    final locale = ref.read(localeProvider);
    ref.read(cipherViewModelProvider.notifier).encrypt(
          _encryptInputController.text,
          _encryptSecretController.text,
          locale,
          useHiddenText: _hideInTextEncrypt,
          useShortOutput: _shortOutputEncrypt,
        );
  }

  void _decrypt() {
    final locale = ref.read(localeProvider);
    ref.read(cipherViewModelProvider.notifier).decrypt(
          _decryptInputController.text,
          _decryptSecretController.text,
          locale,
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
    final viewModel = ref.watch(cipherViewModelProvider);
    final locale = ref.watch(localeProvider);
    final isDesktop = _isDesktop(context);
    final dir = AppStrings.textDirection(locale);

    void onThemeToggle() {
      ref.read(themeModeProvider.notifier).state =
          ref.read(themeModeProvider) == ThemeMode.light
              ? ThemeMode.dark
              : ThemeMode.light;
    }

    void onLocaleToggle() {
      ref.read(localeProvider.notifier).state =
          locale.languageCode == 'fa' ? const Locale('en') : const Locale('fa', 'IR');
    }

    return Directionality(
      textDirection: dir,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: isDesktop
                    ? _buildDesktopLayout(context, locale, viewModel, onThemeToggle, onLocaleToggle)
                    : _buildMobileLayout(context, locale, viewModel, onThemeToggle, onLocaleToggle),
              ),
              VersionFooter(locale: locale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    Locale locale,
    CipherViewModel viewModel,
    VoidCallback onThemeToggle,
    VoidCallback onLocaleToggle,
  ) {
    final padding = _contentPadding(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CodisHeader(
          locale: locale,
          onThemeToggle: onThemeToggle,
          onLocaleToggle: onLocaleToggle,
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
                            isLoading: viewModel.encryptLoading,
                            error: viewModel.encryptError,
                            result: viewModel.encryptResult,
                            onCopy: () => _showCopied(context),
                            showHideInTextSwitch: true,
                            hideInTextValue: _hideInTextEncrypt,
                            onHideInTextChanged: (v) => setState(() => _hideInTextEncrypt = v),
                            shortOutputValue: _shortOutputEncrypt,
                            onShortOutputChanged: (v) => setState(() => _shortOutputEncrypt = v),
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
                            isLoading: viewModel.decryptLoading,
                            error: viewModel.decryptError,
                            result: viewModel.decryptResult,
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

  Widget _buildMobileLayout(
    BuildContext context,
    Locale locale,
    CipherViewModel viewModel,
    VoidCallback onThemeToggle,
    VoidCallback onLocaleToggle,
  ) {
    final padding = _contentPadding(context);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: CodisHeader(
            locale: locale,
            onThemeToggle: onThemeToggle,
            onLocaleToggle: onLocaleToggle,
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
                  ? _mobileEncryptCard(locale, viewModel)
                  : _mobileDecryptCard(locale, viewModel),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _mobileEncryptCard(Locale locale, CipherViewModel viewModel) {
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
        isLoading: viewModel.encryptLoading,
        error: viewModel.encryptError,
        result: viewModel.encryptResult,
        onCopy: () => _showCopied(context),
        showHideInTextSwitch: true,
        hideInTextValue: _hideInTextEncrypt,
        onHideInTextChanged: (v) => setState(() => _hideInTextEncrypt = v),
        shortOutputValue: _shortOutputEncrypt,
        onShortOutputChanged: (v) => setState(() => _shortOutputEncrypt = v),
      ),
    );
  }

  Widget _mobileDecryptCard(Locale locale, CipherViewModel viewModel) {
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
        isLoading: viewModel.decryptLoading,
        error: viewModel.decryptError,
        result: viewModel.decryptResult,
        onCopy: () => _showCopied(context),
      ),
    );
  }

  void _showCopied(BuildContext context) {
    final locale = ref.read(localeProvider);
    final dir = AppStrings.textDirection(locale);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.copied(locale), textDirection: dir),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
