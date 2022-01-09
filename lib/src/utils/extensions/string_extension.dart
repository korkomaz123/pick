extension extString on String {
  bool get isValidName {
    final nameRegExp = new RegExp(r"^\s*([A-Za-z\u0621-\u064A]{1,}([\.,] |[-']| ))+[A-Za-z\u0621-\u064A]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }
}
