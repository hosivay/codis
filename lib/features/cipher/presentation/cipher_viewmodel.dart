import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';

import 'package:codis/core/l10n/app_strings.dart';
import 'package:codis/features/cipher/data/cipher_repository.dart';
import 'package:codis/features/cipher/data/cipher_repository_impl.dart';
import 'package:codis/core/utils/persian_encoding.dart';

class CipherViewModel {
  CipherViewModel({CipherRepository? repository})
      : _repository = repository ?? CipherRepositoryImpl();

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

  void encrypt(String plainText, String secret, Locale locale, void Function() onUpdate) {
    if (plainText.trim().isEmpty) {
      _encryptError = AppStrings.errorEmptyInput(locale);
      _encryptResult = null;
      onUpdate();
      return;
    }
    if (secret.trim().isEmpty) {
      _encryptError = AppStrings.errorEmptySecret(locale);
      _encryptResult = null;
      onUpdate();
      return;
    }
    _encryptError = null;
    _encryptLoading = true;
    onUpdate();
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      _repository.encryptAsync(plainText.trim(), secret).then((result) {
        _encryptResult = result;
        _encryptLoading = false;
        onUpdate();
      }).catchError((_) {
        _encryptError = AppStrings.errorDecryptFailed(locale);
        _encryptResult = null;
        _encryptLoading = false;
        onUpdate();
      });
    });
  }

  void decrypt(String cipherPersian, String secret, Locale locale, void Function() onUpdate) {
    if (cipherPersian.trim().isEmpty) {
      _decryptError = AppStrings.errorEmptyInput(locale);
      _decryptResult = null;
      onUpdate();
      return;
    }
    if (secret.trim().isEmpty) {
      _decryptError = AppStrings.errorEmptySecret(locale);
      _decryptResult = null;
      onUpdate();
      return;
    }
    _decryptError = null;
    _decryptResult = null;
    _decryptLoading = true;
    onUpdate();
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      final trimmed = cipherPersian.trim();
      try {
        persianDecode(trimmed);
      } on FormatException {
        _decryptError = AppStrings.errorInvalidCipher(locale);
        _decryptResult = null;
        _decryptLoading = false;
        onUpdate();
        return;
      }
      _repository.decryptAsync(trimmed, secret).then((result) {
        _decryptResult = result;
        _decryptLoading = false;
        onUpdate();
      }).catchError((_) {
        _decryptError = AppStrings.errorDecryptFailed(locale);
        _decryptResult = null;
        _decryptLoading = false;
        onUpdate();
      });
    });
  }
}
