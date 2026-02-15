import 'package:flutter_test/flutter_test.dart';

import 'package:Codis/core/utils/hidden_text_encoding.dart';

void main() {
  test('encode then extract returns same cipher', () {
    const cipher = 'ابپتثجچ';
    final visible = encodeCipherToVisible(cipher);
    final wrapped = wrapWithCoverText(visible, 'امروز هوا خوبه.');
    final extracted = extractCipherFromText(wrapped);
    expect(extracted, cipher);
  });

  test('extractCipherFromText returns null when no markers', () {
    expect(extractCipherFromText('فقط یک متن معمولی'), isNull);
    expect(extractCipherFromText(''), isNull);
  });

  test('extract then decrypt flow: raw cipher unchanged', () {
    const rawCipher = '۰۱۲۳۴۵۶۷۸۹';
    expect(extractCipherFromText(rawCipher), isNull);
  });

  test('short format encode then extract returns same cipher', () {
    const cipher = 'ابپتثجچ';
    final visible = encodeCipherToVisible(cipher, shortFormat: true);
    final wrapped = wrapShortPayload(visible);
    final extracted = extractCipherFromText(wrapped);
    expect(extracted, cipher);
  });
}
