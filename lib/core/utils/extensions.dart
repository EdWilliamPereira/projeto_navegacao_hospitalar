import 'dart:math';

/// Dart extension methods for common utilities.
extension StringExtensions on String {
  /// Capitalizes the first letter of the string.
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension DoubleExtensions on double {
  /// Rounds to a specific number of decimal places.
  double toDecimalPlaces(int places) {
    final multiplier = pow(10, places).toInt();
    return (this * multiplier).round() / multiplier;
  }
}
