const String _persianDigits = '۰۱۲۳۴۵۶۷۸۹';
const String _englishDigits = '0123456789';

String toPersianDigits(String text) {
  final buffer = StringBuffer();
  for (final rune in text.runes) {
    final char = String.fromCharCode(rune);
    final idx = _englishDigits.indexOf(char);
    buffer.write(idx >= 0 ? _persianDigits[idx] : char);
  }
  return buffer.toString();
}

String toPersianDigitsFromInt(int value) {
  return toPersianDigits(value.toString());
}
