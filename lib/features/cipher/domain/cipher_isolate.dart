import 'package:codis/features/cipher/domain/cipher_service.dart';

String encryptInIsolate((String, String) args) {
  return CipherService().encrypt(args.$1, args.$2);
}

String decryptInIsolate((String, String) args) {
  return CipherService().decrypt(args.$1, args.$2);
}
