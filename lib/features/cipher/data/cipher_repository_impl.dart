import 'package:flutter/foundation.dart';

import 'package:Codis/features/cipher/data/cipher_repository.dart';
import 'package:Codis/features/cipher/domain/cipher_isolate.dart';
import 'package:Codis/features/cipher/domain/cipher_service.dart';

class CipherRepositoryImpl implements CipherRepository {
  CipherRepositoryImpl({CipherService? cipherService})
      : _cipherService = cipherService ?? CipherService();

  final CipherService _cipherService;

  @override
  String encrypt(String plainText, String secret) {
    return _cipherService.encrypt(plainText, secret);
  }

  @override
  String decrypt(String cipherBase64, String secret) {
    return _cipherService.decrypt(cipherBase64, secret);
  }

  @override
  Future<String> encryptAsync(String plainText, String secret) {
    return compute(encryptInIsolate, (plainText, secret));
  }

  @override
  Future<String> decryptAsync(String cipherText, String secret) {
    return compute(decryptInIsolate, (cipherText, secret));
  }
}
