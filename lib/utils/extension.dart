import 'dart:math';

import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String formatISOTime() {
    String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(this);

// Add the timezone offset
    Duration offset = timeZoneOffset;
    String offsetSign = offset.isNegative ? '-' : '+';
    String offsetHours = (offset.inHours % 24).toString().padLeft(2, '0');
    String offsetMinutes = (offset.inMinutes % 60).toString().padLeft(2, '0');

    formattedDate += '$offsetSign$offsetHours:$offsetMinutes';

// Output: 2024-05-13T17:23:48+05:30
    return formattedDate;
  }
}

extension StringExtensions on String {
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final _rnd = Random();

  String getOrderId(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

extension DateFormatExtension on DateTime {
  String toFormattedString() {
    return DateFormat('yyyyMMddHHmmss').format(this);
  }
}

DateTime getCurrentTimestamp() {
  return DateTime.now();
}

extension DateFormatting on String {
  String toFormattedDate() {
    try {
      DateTime dateTime = DateTime.parse(this);
      DateFormat formatter = DateFormat('MMMM dd, yyyy hh:mm a');
      return formatter.format(dateTime.toLocal());
    } catch (e) {
      // Handle parsing error if the string is not a valid date
      return 'Invalid date';
    }
  }
}

extension RupeeFormat on String {
  String toRupee() {
    try {
      final double amount = double.parse(this);
      final format = NumberFormat.currency(locale: "en_IN", symbol: "₹ ");
      return format.format(amount);
    } catch (e) {
      return "Invalid amount";
    }
  }
}

double convertToDouble(String amount) {
  // Parse the string to a double
  double parsedAmount = double.tryParse(amount) ?? 0.0;
  // Round to two decimal places
  return double.parse(parsedAmount.toStringAsFixed(2));
}

extension AmountFormatter on String? {
  /// Cleans and formats the string amount, allowing only numeric and decimal values.
  /// Returns the formatted amount as a string with two decimal places.
  String formatAsCurrency() {
    if (this == null || this!.isEmpty) {
      return '0.00';
    }

    // Remove any characters that are not digits or decimal points
    String cleanAmount = this!.replaceAll(RegExp(r'[^\d.]'), '');

    // Parse the cleaned amount to a double and format it to two decimal places
    double decimalAmount = double.tryParse(cleanAmount) ?? 0.0;
    return decimalAmount.toStringAsFixed(2);
  }
}
