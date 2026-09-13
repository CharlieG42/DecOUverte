import 'dart:ui';

/// Configuration du projet DéCOuverte.
///
/// La charte graphique (logo, fond, boussole, titre, accroche) est intégrée
/// dans le PDF template vierge — il n'y a plus d'assets séparés à gérer.
///
/// Ce fichier contient uniquement les coordonnées des zones éditables
/// (en pourcentage de la page A4) et les styles de texte overlay.
class AppConstants {
  AppConstants._();

  // ── Format de sortie ──
  static const double posterWidthMm = 210.0;  // A4 portrait
  static const double posterHeightMm = 297.0;
  static const double mmToPt = 72.0 / 25.4;   // 1 mm = 2.8346 pt

  // ── Template PDF ──
  static const String templatePath = 'assets/templates/template_vierge.pdf';

  // ── Polices overlay ──
  static const String fontBody = 'Nunito';

  // ── Couleurs overlay ──
  static const Color black    = Color(0xFF000000);
  static const Color blueLogo = Color(0xFF00A2E8);
  static const Color white    = Color(0xFFFFFFFF);

  // ── Coordonnées des zones éditables (en % de la page) ──
  // x%, y% = position du CENTRE de la zone (sauf pour les blocs gauche/droite)
  // largeur% = largeur de la zone en % de la page

  static const Zone dateZone = Zone(centerX: 50, topY: 55, widthPct: 60, align: ZoneAlign.center);
  static const Zone locationZone = Zone(centerX: 50, topY: 60, widthPct: 70, align: ZoneAlign.center);
  static const Zone eventTypeZone = Zone(centerX: 50, topY: 66, widthPct: 84, align: ZoneAlign.center);
  static const Zone audienceZone = Zone(centerX: 50, topY: 69, widthPct: 84, align: ZoneAlign.center);
  static const Zone timeSlotZone = Zone(centerX: 50, topY: 72, widthPct: 84, align: ZoneAlign.center);

  // Blocs en bas de page
  static const Zone registrationZone = Zone(leftX: 8, topY: 88, widthPct: 40, align: ZoneAlign.left);
  static const Zone phoneZone = Zone(leftX: 8, topY: 93, widthPct: 40, align: ZoneAlign.left);
  static const Zone qrZone = Zone(rightX: 92, topY: 88, widthPct: 18, align: ZoneAlign.right);
  static const Zone scanTextZone = Zone(rightX: 92, topY: 96, widthPct: 18, align: ZoneAlign.right);

  // ── Textes fixes ──
  static const String scanText = 'Scannez ou Cliquez\npour vous inscrire !';
}

/// Position d'une zone éditable sur l'affiche, en pourcentage de la page.
class Zone {
  final double? centerX;   // % depuis gauche (centre horizontal)
  final double? leftX;     // % depuis gauche (bord gauche)
  final double? rightX;    // % depuis gauche (bord droit)
  final double topY;       // % depuis haut
  final double widthPct;  // largeur en %
  final ZoneAlign align;

  const Zone({
    this.centerX,
    this.leftX,
    this.rightX,
    required this.topY,
    required this.widthPct,
    required this.align,
  });
}

enum ZoneAlign { left, center, right }
