import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  /// Formatea siempre con 2 decimales, ej: 1234.5 -> "$1,234.50"
  static String format(double amount) => _formatter.format(amount);
}