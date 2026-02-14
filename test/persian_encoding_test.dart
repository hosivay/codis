import 'dart:math';

import 'package:codis/core/utils/persian_encoding.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('encode then decode roundtrip', () {
    final rand = Random(42);
    for (var len = 1; len <= 100; len++) {
      final bytes = List<int>.generate(len, (_) => rand.nextInt(256));
      final encoded = persianEncode(bytes);
      final decoded = persianDecode(encoded);
      expect(decoded, bytes);
    }
  });

  test('decode ignores whitespace', () {
    final bytes = [72, 101, 108, 108, 111];
    final encoded = persianEncode(bytes);
    final withSpaces = '  $encoded  \n  ';
    final decoded = persianDecode(withSpaces);
    expect(decoded, bytes);
  });
}
