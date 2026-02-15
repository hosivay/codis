import 'package:flutter/material.dart';

class AppStrings {
  AppStrings._();

  static String appName(Locale locale) =>
      locale.languageCode == 'en' ? 'Codis' : 'کدیس';

  static String tagline(Locale locale) =>
      locale.languageCode == 'en'
          ? 'Secure text encryption and decryption'
          : 'رمزنگاری و رمزگشایی امن متن';

  static String encryptTitle(Locale locale) =>
      locale.languageCode == 'en' ? 'Encrypt' : 'رمزنگاری';

  static String encryptSubtitle(Locale locale) =>
      locale.languageCode == 'en'
          ? 'Lock your text with a secret key'
          : 'متن خود را با کلید رمز قفل کنید';

  static String decryptTitle(Locale locale) =>
      locale.languageCode == 'en' ? 'Decrypt' : 'رمزگشایی';

  static String decryptSubtitle(Locale locale) =>
      locale.languageCode == 'en'
          ? 'Open encrypted text with the same key'
          : 'متن رمزشده را با همان کلید باز کنید';

  static String inputHintEncrypt(Locale locale) =>
      locale.languageCode == 'en' ? 'Enter text...' : 'متن را وارد کنید...';

  static String inputHintDecrypt(Locale locale) =>
      locale.languageCode == 'en'
          ? 'Paste encrypted text here...'
          : 'متن رمزشده را اینجا بچسبانید...';

  static String secretHint(Locale locale) =>
      locale.languageCode == 'en' ? 'Secret key' : 'کلید رمز';

  static String doEncrypt(Locale locale) =>
      locale.languageCode == 'en' ? 'Encrypt' : 'رمزنگاری';

  static String doDecrypt(Locale locale) =>
      locale.languageCode == 'en' ? 'Decrypt' : 'رمزگشایی';

  static String resultLabel(Locale locale) =>
      locale.languageCode == 'en' ? 'Result' : 'نتیجه';

  static String copyResult(Locale locale) =>
      locale.languageCode == 'en' ? 'Copy' : 'کپی';

  static String copied(Locale locale) =>
      locale.languageCode == 'en' ? 'Copied' : 'کپی شد';

  static String shareResult(Locale locale) =>
      locale.languageCode == 'en' ? 'Share' : 'اشتراک\u200cگذاری';

  static String viewFullScreen(Locale locale) =>
      locale.languageCode == 'en' ? 'Full screen' : 'تمام صفحه';

  static String errorInvalidCipher(Locale locale) =>
      locale.languageCode == 'en'
          ? 'Invalid encrypted text'
          : 'متن رمزشده معتبر نیست';

  static String errorDecryptFailed(Locale locale) =>
      locale.languageCode == 'en'
          ? 'Decryption failed. Check the key.'
          : 'رمزگشایی ناموفق. کلید را بررسی کنید.';

  static String errorEmptyInput(Locale locale) =>
      locale.languageCode == 'en' ? 'Enter text' : 'متن را وارد کنید';

  static String errorEmptySecret(Locale locale) =>
      locale.languageCode == 'en' ? 'Enter secret key' : 'کلید رمز را وارد کنید';

  static String versionLabel(Locale locale) =>
      locale.languageCode == 'en' ? 'Version' : 'ورژن';

  static String hideInTextLabel(Locale locale) =>
      locale.languageCode == 'en'
          ? 'Hide in normal text'
          : 'مخفی در متن معمولی';

  static String hideInTextCover(Locale locale) =>
      locale.languageCode == 'en'
          ? 'Hope you\'re doing well. Talk soon!'
          : 'امروز هوا خوبه. وقتی وقت داشتی جواب بده.';

  static String shortOutputLabel(Locale locale) =>
      locale.languageCode == 'en'
          ? 'Shorter encrypted message'
          : 'متن رمزشده کوتاه\u200cتر';

  static TextDirection textDirection(Locale locale) =>
      locale.languageCode == 'en' ? TextDirection.ltr : TextDirection.rtl;
}
