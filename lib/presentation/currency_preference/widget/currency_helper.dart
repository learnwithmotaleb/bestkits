import 'package:bestkits/helper/local_db/local_db.dart';

class CurrencyHelper {
  static const List<Map<String, String>> currencies = [
    {'name': 'USD', 'symbol': '\$'},
    {'name': 'EUR', 'symbol': '€'},
    {'name': 'AED', 'symbol': 'د.إ'},
    {'name': 'GBP', 'symbol': '£'},
  ];

  /// Get the currently selected currency code (e.g., 'USD', 'EUR')
  static String get currentCurrencyCode {
    return SharePrefsHelper.getCurrency() ?? 'USD';
  }

  /// Get the current currency symbol (e.g., '\$', '€')
  static String get currentSymbol {
    final currencyName = currentCurrencyCode;
    final currency = currencies.firstWhere(
      (c) => c['name'] == currencyName,
      orElse: () => currencies.first,
    );
    return currency['symbol']!;
  }

  /// Helper to format a price with the current currency symbol
  /// Example: CurrencyHelper.formatPrice(10.50) => "$10.50" or "€10.50"
  static String formatPrice(dynamic price) {
    double parsedPrice = 0.0;
    if (price is num) {
      parsedPrice = price.toDouble();
    } else if (price is String) {
      parsedPrice = double.tryParse(price) ?? 0.0;
    }
    
    // Formatting with 2 decimal places, removing .00 if it's an integer could be done here if needed.
    return '$currentSymbol${parsedPrice.toStringAsFixed(2)}';
  }
}
