import 'dart:math';

class StringService {
  static double roundDouble(String value, int places) {
    double mod = pow(10.0, places);
    return ((double.parse(value) * mod).round().toDouble() / mod);
  }

  static String roundString(String value, int places) {
    double mod = pow(10.0, places);
    return ((double.parse(value) * mod).round().toDouble() / mod)
        .toStringAsFixed(3);
  }
}
