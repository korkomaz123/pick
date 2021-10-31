import 'dart:math';

class StringService {
  static double roundDouble(String? value, int places) {
    num mod = pow(10.0, places);
    return ((double.parse(value ?? '0') * mod).round().toDouble() / mod);
  }

  static String roundString(String? value, int places) {
    num mod = pow(10.0, places);
    return ((double.parse(value ?? '0') * mod).round().toDouble() / mod)
        .toStringAsFixed(3);
  }
}
