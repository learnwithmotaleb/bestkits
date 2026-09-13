import 'package:get/get.dart';

/// Translate known UI text without changing unknown server messages or details.
String localizeMessage(String message) {
  final translated = message.tr;
  if (translated != message) return translated;

  const numericTemplates = [
    'Must be at least @value characters',
    'Must be at most @value characters',
    'Must be exactly @value characters',
    'Password must be at least @value characters',
    'Password must be at most @value characters',
    'OTP must be @value digits',
    'Must be ≥ @value',
    'Must be ≤ @value',
  ];
  for (final template in numericTemplates) {
    final parts = template.split('@value');
    if (message.startsWith(parts.first) && message.endsWith(parts.last)) {
      final end = message.length - parts.last.length;
      if (end < parts.first.length) continue;
      final value = message.substring(parts.first.length, end);
      if (num.tryParse(value) != null) {
        return template.trParams({'value': value});
      }
    }
  }

  const prefixes = [
    'An error occurred: ',
    'An error occurred during login: ',
    'Error fetching summary: ',
    'Failed to resend OTP: ',
    'Error: ',
  ];
  for (final prefix in prefixes) {
    if (message.startsWith(prefix)) {
      return '$prefix@detail'.trParams({
        'detail': message.substring(prefix.length),
      });
    }
  }
  return message;
}
