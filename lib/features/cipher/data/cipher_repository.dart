abstract class CipherRepository {
  String encrypt(String plainText, String secret);
  String decrypt(String cipherBase64, String secret);
  Future<String> encryptAsync(String plainText, String secret);
  Future<String> decryptAsync(String cipherText, String secret);
}
