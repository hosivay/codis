const String _chars = '۰۱۲۳۴۵۶۷۸۹ابپتثجچحخدرزژسشصضطظعغفقکگلمنوهیءآأةأؤإئًٌٍَُِّْٕٖٜٓٔٗ٘ٙٚٛٝٞ';

final List<int> _charRunes = () {
  final runes = _chars.runes.toList();
  final seen = <int>{};
  final out = <int>[];
  for (final r in runes) {
    if (!seen.contains(r)) {
      seen.add(r);
      out.add(r);
      if (out.length == 64) return out;
    }
  }
  const extra = [0x065D, 0x065E, 0x065F, 0x0660, 0x0661];
  for (final r in extra) {
    if (out.length < 64 && !seen.contains(r)) {
      seen.add(r);
      out.add(r);
    }
  }
  return out;
}();

final Map<int, int> _runeToIndex = () {
  final m = <int, int>{};
  for (var i = 0; i < _charRunes.length; i++) {
    m[_charRunes[i]] = i;
  }
  const int kafPersian = 0x06A9;
  const int kafArabic = 0x0643;
  const int yehPersian = 0x06CC;
  const int yehArabic = 0x064A;
  if (m.containsKey(kafPersian)) m[kafArabic] = m[kafPersian]!;
  if (m.containsKey(yehPersian)) m[yehArabic] = m[yehPersian]!;
  return m;
}();

String persianEncode(List<int> bytes) {
  final sb = StringBuffer();
  int i = 0;
  while (i < bytes.length) {
    final b0 = bytes[i++];
    sb.writeCharCode(_charRunes[b0 >> 2]);
    if (i < bytes.length) {
      final b1 = bytes[i++];
      sb.writeCharCode(_charRunes[((b0 & 3) << 4) | (b1 >> 4)]);
      if (i < bytes.length) {
        final b2 = bytes[i++];
        sb.writeCharCode(_charRunes[((b1 & 15) << 2) | (b2 >> 6)]);
        sb.writeCharCode(_charRunes[b2 & 63]);
      } else {
        sb.writeCharCode(_charRunes[(b1 & 15) << 2]);
      }
    } else {
      sb.writeCharCode(_charRunes[(b0 & 3) << 4]);
    }
  }
  return sb.toString();
}

int _runeIndex(int rune) {
  final idx = _runeToIndex[rune];
  if (idx == null) throw FormatException('invalid');
  return idx;
}

List<int> persianDecode(String s) {
  final normalized = s.replaceAll(RegExp(r'\s'), '');
  final runes = normalized.runes.toList();
  final filtered = <int>[];
  for (final r in runes) {
    if (_runeToIndex.containsKey(r)) filtered.add(r);
  }
  if (filtered.isEmpty) throw FormatException('invalid');
  final pad = filtered.length % 4;
  if (pad == 1) throw FormatException('invalid');
  final out = <int>[];
  final n = filtered.length;
  var i = 0;
  while (i + 3 < n) {
    final c0 = _runeIndex(filtered[i++]);
    final c1 = _runeIndex(filtered[i++]);
    final c2 = _runeIndex(filtered[i++]);
    final c3 = _runeIndex(filtered[i++]);
    out.add((c0 << 2) | (c1 >> 4));
    out.add(((c1 & 15) << 4) | (c2 >> 2));
    out.add(((c2 & 3) << 6) | c3);
  }
  if (pad == 2) {
    final c0 = _runeIndex(filtered[n - 2]);
    final c1 = _runeIndex(filtered[n - 1]);
    out.add((c0 << 2) | (c1 >> 4));
  } else if (pad == 3) {
    final c0 = _runeIndex(filtered[n - 3]);
    final c1 = _runeIndex(filtered[n - 2]);
    final c2 = _runeIndex(filtered[n - 1]);
    out.add((c0 << 2) | (c1 >> 4));
    out.add(((c1 & 15) << 4) | (c2 >> 2));
  }
  return out;
}
