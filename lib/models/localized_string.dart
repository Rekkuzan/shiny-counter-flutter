class LocalizedString {
  Map<String, String>? _values;

  LocalizedString(Map<String, dynamic> data) {
    _values = data.cast<String, String>();
  }

  String getValue(String languageCode) {
    if (_values == null) {
      return "??";
    }
    return _values![languageCode]!;
  }
}