import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  /// Formate la date en français : "4 OCTOBRE 2026"
  static String formatDate(DateTime date) {
    final day = date.day.toString();
    final month = DateFormat('MMMM', 'fr_FR').format(date).toUpperCase();
    final year = date.year.toString();
    return '$day $month $year';
  }

  /// Nettoie une URL pour le QR code (ajoute https:// si nécessaire)
  static String normalizeUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return 'https://$trimmed';
  }

  /// Formate un numéro de téléphone : "07 79 61 34 45" → "07.79.61.34.45"
  static String formatPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length >= 10) {
      final parts = <String>[];
      for (var i = 0; i < 10; i += 2) {
        parts.add(digits.substring(i, i + 2));
      }
      return parts.join('.');
    }
    return phone;
  }
}
