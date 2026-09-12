import 'dart:ui';

/// Charte graphique du projet DéCOuverte.
/// Toutes les valeurs sont extraites de l'affiche de référence
/// et doivent rester fixes pour garantir la cohérence entre affiches.
class AppConstants {
  AppConstants._();

  // ── Format de sortie ──
  static const double posterWidthMm = 210.0;  // A4 portrait
  static const double posterHeightMm = 297.0;
  static const double mmToPt = 72.0 / 25.4;   // 1 mm = 2.8346 pt

  // ── Palette ──
  static const Color blueLogo    = Color(0xFF00A2E8);
  static const Color greenLogo   = Color(0xFF7ED321);
  static const Color greenRunner = Color(0xFFA4C639);
  static const Color blueRunner  = Color(0xFF00A8E0);
  static const Color black       = Color(0xFF000000);
  static const Color bgTop       = Color(0xFFD9E6A2);
  static const Color bgBottom    = Color(0xFFF5F5DC);
  static const Color compassBeige = Color(0xFF8B7D6B);

  // ── Polices ──
  static const String fontTitle = 'Comfortaa';   // logo + titre
  static const String fontBody  = 'Nunito';       // texte courant

  // ── Assets fixes ──
  static const String assetLogo      = 'assets/charter/logo_crra.jpeg';
  static const String assetBackground = 'assets/charter/background_runners.jpeg';
  static const String assetCompass    = 'assets/charter/compass_rose.jpeg';

  // ── Textes fixes ──
  static const String titleText = 'DéCOUverte';
  static const String subtitleText =
      'EN FAMILLE OU ENTRE AMIS, VENEZ DÉCOUVRIR\n'
      'LA COURSE D\'ORIENTATION...\n'
      'ON VOUS EXPLIQUERA TOUT.';
  static const String scanText = 'Scannez ou Cliquez\npour vous inscrire !';
}
