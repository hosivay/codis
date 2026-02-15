import 'package:Codis/core/utils/persian_encoding.dart';

const String _marker = '||';

const List<String> _shortWordList = [
  'تو', 'او', 'من', 'نه', 'هست', 'بود', 'شد', 'کن',
  'گیر', 'زن', 'مرد', 'سر', 'دست', 'پا', 'چشم', 'دهان',
  'نان', 'جان', 'مان', 'نور', 'طور', 'دور', 'کار', 'بار',
  'دار', 'یار', 'نار', 'پار', 'تار', 'مار', 'شار', 'خار',
  'جار', 'رار', 'سار', 'گار', 'لار', 'وار', 'هار', 'ژار',
  'کان', 'بان', 'وان', 'گان', 'ران', 'سان', 'تان', 'شان',
  'خان', 'زان', 'خون', 'رنگ', 'سنگ', 'تنگ', 'جنگ', 'مرگ',
  'برگ', 'ترک', 'مهر', 'شهر', 'زود', 'دیر', 'بیش', 'زیر',
];

final Map<String, int> _shortWordToIndex = () {
  final m = <String, int>{};
  for (var i = 0; i < _shortWordList.length; i++) {
    m[_shortWordList[i]] = i;
  }
  return m;
}();

const List<String> _wordList = [
  'گل', 'درخت', 'کتاب', 'ماه', 'آب', 'هوا', 'روز', 'شب',
  'خانه', 'در', 'با', 'از', 'برای', 'این', 'آن', 'ما',
  'شما', 'خوب', 'بد', 'بزرگ', 'کوچک', 'نو', 'قدیم', 'سبز',
  'سرخ', 'زرد', 'سفید', 'سیاه', 'گرم', 'سرد', 'تند', 'کند',
  'را', 'به', 'که', 'اگر', 'چون', 'یا', 'نه', 'هم',
  'چه', 'فقط', 'پس', 'پیش', 'بعد', 'قبل', 'بالا', 'پایین',
  'داخل', 'بیرون', 'امروز', 'فردا', 'دیروز', 'همیشه', 'گاهی', 'بسیار',
  'کم', 'زیاد', 'یکی', 'دو', 'سه', 'چهار', 'پنج', 'شش',
];

final Map<String, int> _wordToIndex = () {
  final m = <String, int>{};
  for (var i = 0; i < _wordList.length; i++) {
    m[_wordList[i]] = i;
  }
  return m;
}();

String encodeCipherToVisible(String persianCipher, {bool shortFormat = false}) {
  final list = shortFormat ? _shortWordList : _wordList;
  final sb = StringBuffer();
  for (var i = 0; i < persianCipher.runes.length; i++) {
    if (i > 0) sb.write(' ');
    final rune = persianCipher.runes.elementAt(i);
    final index = persianRuneToIndex(rune);
    sb.write(list[index]);
  }
  return sb.toString();
}

String? _decodeVisibleToCipher(String payload) {
  final trimmed = payload.trim();
  if (trimmed.isEmpty) return null;
  final tokens = trimmed.split(RegExp(r'\s+'));
  if (tokens.isEmpty) return null;
  final allInShort = tokens.every((t) => _shortWordToIndex.containsKey(t));
  final allInLong = tokens.every((t) => _wordToIndex.containsKey(t));
  final indexMap = allInShort ? _shortWordToIndex : (allInLong ? _wordToIndex : null);
  if (indexMap == null) return null;
  final sb = StringBuffer();
  for (final token in tokens) {
    final index = indexMap[token];
    if (index == null) return null;
    sb.writeCharCode(persianRuneFromIndex(index));
  }
  return sb.toString();
}

String? extractCipherFromText(String text) {
  final idx = text.indexOf(_marker);
  if (idx < 0) return null;
  final payload = text.substring(idx + _marker.length);
  if (payload.isEmpty) return null;
  return _decodeVisibleToCipher(payload);
}

String wrapWithCoverText(String visiblePayload, String coverText) {
  return coverText + _marker + visiblePayload;
}

String wrapShortPayload(String visiblePayload) {
  return _marker + visiblePayload;
}
