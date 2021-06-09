import 'dart:math';

class NumericService {
  static double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  static String roundString(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod).toStringAsFixed(3);
  }
}
