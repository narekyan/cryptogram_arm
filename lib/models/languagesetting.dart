import '../resources.dart';

class LanguageSetting {
  static var armenian = LanguageSetting(
    R.strings.armenianAlphabet,
    R.keys.armenianKeyboardLayout,
  );

  const LanguageSetting(this.alphabet, this.layout);

  final List<String> alphabet;
  final List<int> layout;
}
