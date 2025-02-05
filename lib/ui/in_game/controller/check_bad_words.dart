import 'package:safe_text/safe_text.dart';

/// 종합 필터링
Future<bool> hasBadWords(String inputText) async {
  final hasBadEnglish = await _hasBadEnglish(inputText);
  final hasPhoneNumber = await _hasPhoneNumber(inputText);

  return hasBadEnglish || hasPhoneNumber;
}

/// 영어 욕설 필터링
Future<bool> _hasBadEnglish(String inputText) async {
  final hasBadWords = await SafeText.containsBadWord(text: inputText);

  return hasBadWords;
}

/// 핸드폰 번호 필터링
Future<bool> _hasPhoneNumber(String inputText) async {
  final hasPhoneNumber = await SafeText.containsPhoneNumber(
    text: inputText,
    minLength: 7, // Minimum length for a valid phone number
    maxLength: 15, // Maximum length for a valid phone number
  );

  return hasPhoneNumber;
}
