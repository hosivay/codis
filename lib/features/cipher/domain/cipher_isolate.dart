import 'package:Codis/core/utils/hidden_text_encoding.dart';
import 'package:Codis/core/utils/persian_encoding.dart';
import 'package:Codis/features/cipher/domain/cipher_service.dart';

String encryptInIsolate((String, String) args) {
  return CipherService().encrypt(args.$1, args.$2);
}

String decryptInIsolate((String, String) args) {
  return CipherService().decrypt(args.$1, args.$2);
}

(String?, bool) prepareCipherForDecryptInIsolate(String input) {
  final trimmed = input.trim();
  final cipher = extractCipherFromText(trimmed) ?? trimmed;
  try {
    persianDecode(cipher);
    return (cipher, true);
  } on FormatException {
    return (null, false);
  }
}

String wrapEncryptResultInIsolate((String, bool, String) args) {
  final (result, shortFormat, coverText) = args;
  final visible = encodeCipherToVisible(result, shortFormat: shortFormat);
  return shortFormat ? wrapShortPayload(visible) : wrapWithCoverText(visible, coverText);
}
