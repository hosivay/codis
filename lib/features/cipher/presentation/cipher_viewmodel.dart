import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';

import 'package:Codis/core/l10n/app_strings.dart';
import 'package:Codis/features/cipher/data/cipher_repository.dart';
import 'package:Codis/features/cipher/domain/cipher_isolate.dart';

class CipherViewModel extends ChangeNotifier {
  CipherViewModel({required CipherRepository repository}) : _repository = repository;

  final CipherRepository _repository;

  String? _encryptResult;
  String? get encryptResult => _encryptResult;
  String? _encryptError;
  String? get encryptError => _encryptError;
  bool _encryptLoading = false;
  bool get encryptLoading => _encryptLoading;

  String? _decryptResult;
  String? get decryptResult => _decryptResult;
  String? _decryptError;
  String? get decryptError => _decryptError;
  bool _decryptLoading = false;
  bool get decryptLoading => _decryptLoading;

  void encrypt(String plainText, String secret, Locale locale, {bool useHiddenText = false, bool useShortOutput = false}) {
    if (plainText.trim().isEmpty) {
      _encryptError = AppStrings.errorEmptyInput(locale);
      _encryptResult = null;
      notifyListeners();
      return;
    }
    if (secret.trim().isEmpty) {
      _encryptError = AppStrings.errorEmptySecret(locale);
      _encryptResult = null;
      notifyListeners();
      return;
    }
    _encryptError = null;
    _encryptLoading = true;
    notifyListeners();
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      final start = DateTime.now();
      _repository.encryptAsync(plainText.trim(), secret).then((result) async {
        if (useHiddenText) {
          final cover = AppStrings.hideInTextCover(locale);
          _encryptResult = await compute(
            wrapEncryptResultInIsolate,
            (result, useShortOutput, cover),
          );
        } else {
          _encryptResult = result;
        }
        final elapsed = DateTime.now().difference(start);
        final minDelay = Duration(milliseconds: 650);
        if (elapsed < minDelay) await Future.delayed(minDelay - elapsed);
        _encryptLoading = false;
        notifyListeners();
      }).catchError((_) async {
        final elapsed = DateTime.now().difference(start);
        final minDelay = Duration(milliseconds: 650);
        if (elapsed < minDelay) await Future.delayed(minDelay - elapsed);
        _encryptError = AppStrings.errorDecryptFailed(locale);
        _encryptResult = null;
        _encryptLoading = false;
        notifyListeners();
      });
    });
  }

  void decrypt(String cipherPersian, String secret, Locale locale) {
    if (cipherPersian.trim().isEmpty) {
      _decryptError = AppStrings.errorEmptyInput(locale);
      _decryptResult = null;
      notifyListeners();
      return;
    }
    if (secret.trim().isEmpty) {
      _decryptError = AppStrings.errorEmptySecret(locale);
      _decryptResult = null;
      notifyListeners();
      return;
    }
    _decryptError = null;
    _decryptResult = null;
    _decryptLoading = true;
    notifyListeners();
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      final start = DateTime.now();
      final trimmed = cipherPersian.trim();
      compute(prepareCipherForDecryptInIsolate, trimmed).then((prepareResult) async {
        final (cipher, valid) = prepareResult;
        if (!valid || cipher == null) {
          _decryptError = AppStrings.errorInvalidCipher(locale);
          _decryptResult = null;
          _decryptLoading = false;
          notifyListeners();
          return;
        }
        _repository.decryptAsync(cipher, secret).then((result) async {
          _decryptResult = result;
          final elapsed = DateTime.now().difference(start);
          final minDelay = Duration(milliseconds: 650);
          if (elapsed < minDelay) await Future.delayed(minDelay - elapsed);
          _decryptLoading = false;
          notifyListeners();
        }).catchError((_) async {
          final elapsed = DateTime.now().difference(start);
          final minDelay = Duration(milliseconds: 650);
          if (elapsed < minDelay) await Future.delayed(minDelay - elapsed);
          _decryptError = AppStrings.errorDecryptFailed(locale);
          _decryptResult = null;
          _decryptLoading = false;
          notifyListeners();
        });
      });
    });
  }
}
