import 'package:codis/features/cipher/domain/cipher_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CipherService service;

  setUp(() {
    service = CipherService();
  });

  test('encrypt then decrypt returns original text', () {
    const plain = 'سلام دنیا ۱۲۳';
    const secret = 'کلیدمحبوب';
    final encrypted = service.encrypt(plain, secret);
    expect(encrypted, isNotEmpty);
    expect(encrypted, isNot(equals(plain)));
    final decrypted = service.decrypt(encrypted, secret);
    expect(decrypted, plain);
  });

  test('decrypt with newlines in cipher works', () {
    const plain = 'متن تست';
    const secret = 'secret123';
    final encrypted = service.encrypt(plain, secret);
    final mid = encrypted.length ~/ 2;
    final withNewlines = '${encrypted.substring(0, mid)}\n\n${encrypted.substring(mid)}';
    final decrypted = service.decrypt(withNewlines, secret);
    expect(decrypted, plain);
  });

  test('decrypt with wrong secret throws', () {
    const plain = 'متن';
    const secret = 'right';
    final encrypted = service.encrypt(plain, secret);
    expect(() => service.decrypt(encrypted, 'wrong'), throwsA(anything));
  });
}
