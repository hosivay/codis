import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart';

import 'package:Codis/core/utils/persian_encoding.dart';

class CipherService {
  static const int _saltLength = 16;
  static const int _ivLength = 16;
  static const int _tagLength = 32;
  static const int _pbkdf2Iterations = 6000;
  static const int _derivedKeyLength = 64;

  String encrypt(String plainText, String secret) {
    final salt = _secureRandomBytes(_saltLength);
    final iv = IV.fromSecureRandom(_ivLength);
    final (keyAes, keyHmac) = _deriveKeys(secret, salt);
    final encrypter = Encrypter(AES(Key(keyAes), mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final cipherBytes = encrypted.bytes;
    final tag = _hmac(keyHmac, salt, iv.bytes, cipherBytes);
    final combined = [
      salt,
      iv.bytes,
      cipherBytes,
      tag,
    ].expand((e) => e).toList();
    return persianEncode(combined);
  }

  String decrypt(String cipherPersian, String secret) {
    final raw = persianDecode(cipherPersian);
    const headerLength = _saltLength + _ivLength + _tagLength;
    if (raw.length < headerLength) {
      throw FormatException('invalid');
    }
    final salt = Uint8List.fromList(raw.sublist(0, _saltLength));
    final iv = IV(Uint8List.fromList(raw.sublist(_saltLength, _saltLength + _ivLength)));
    final tagStart = raw.length - _tagLength;
    final cipherBytes = Uint8List.fromList(raw.sublist(_saltLength + _ivLength, tagStart));
    final tag = raw.sublist(tagStart);
    final (keyAes, keyHmac) = _deriveKeys(secret, salt);
    final expectedTag = _hmac(keyHmac, salt, raw.sublist(_saltLength, _saltLength + _ivLength), cipherBytes);
    if (!_constantTimeEquals(tag, expectedTag)) {
      throw FormatException('invalid');
    }
    final encrypter = Encrypter(AES(Key(keyAes), mode: AESMode.cbc));
    final encrypted = Encrypted(cipherBytes);
    return encrypter.decrypt(encrypted, iv: iv);
  }

  (Uint8List, Uint8List) _deriveKeys(String secret, Uint8List salt) {
    final passwordBytes = Uint8List.fromList(utf8.encode(secret));
    final derivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    derivator.init(Pbkdf2Parameters(salt, _pbkdf2Iterations, _derivedKeyLength));
    final derived = Uint8List(_derivedKeyLength);
    derivator.deriveKey(passwordBytes, 0, derived, 0);
    return (
      Uint8List.fromList(derived.sublist(0, 32)),
      Uint8List.fromList(derived.sublist(32, 64)),
    );
  }

  List<int> _hmac(Uint8List key, List<int> salt, List<int> iv, Uint8List ciphertext) {
    final hmac = Hmac(sha256, key);
    final data = [...salt, ...iv, ...ciphertext];
    final digest = hmac.convert(data);
    return digest.bytes;
  }

  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }

  Uint8List _secureRandomBytes(int length) {
    final iv = IV.fromSecureRandom(length);
    return iv.bytes;
  }
}
