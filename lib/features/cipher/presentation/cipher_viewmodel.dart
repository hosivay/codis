import 'package:flutter/scheduler.dart';

import 'package:codis/core/constants/app_constants.dart';
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

  void encrypt(String plainText, String secret, void Function() onUpdate) {
    if (plainText.trim().isEmpty) {
      _encryptError = AppConstants.errorEmptyInput;
      _encryptResult = null;
      onUpdate();
      return;
    }
    if (secret.trim().isEmpty) {
      _encryptError = AppConstants.errorEmptySecret;
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
        _encryptError = AppConstants.errorDecryptFailed;
        _encryptResult = null;
        _encryptLoading = false;
        onUpdate();
      });
    });
  }

  void decrypt(String cipherPersian, String secret, void Function() onUpdate) {
    if (cipherPersian.trim().isEmpty) {
      _decryptError = AppConstants.errorEmptyInput;
      _decryptResult = null;
      onUpdate();
      return;
    }
    if (secret.trim().isEmpty) {
      _decryptError = AppConstants.errorEmptySecret;
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
        _decryptError = AppConstants.errorInvalidCipher;
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
        _decryptError = AppConstants.errorDecryptFailed;
        _decryptResult = null;
        _decryptLoading = false;
        onUpdate();
      });
    });
  }
}
