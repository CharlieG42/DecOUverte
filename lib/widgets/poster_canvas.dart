import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../constants.dart';
import '../models/event_data.dart';
import '../utils/formatters.dart';

/// Aperçu de l'affiche à l'écran.
///
/// Affiche le template vierge en fond + overlay des zones éditables.
/// Utilise les mêmes coordonnées que le générateur PDF pour garantir
/// la cohérence entre aperçu et export.
class PosterCanvas extends StatelessWidget {
  const PosterCanvas({
    super.key,
    required this.event,
  });

  final EventData event;

  @override
  Widget build(BuildContext context) {
    const aspectRatio = 210.0 / 297.0;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          return Stack(
            children: [
              // ── Fond : template vierge ──
              // En attendant le template PDF, on affiche un placeholder coloré
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFD9E6A2), Color(0xFFF5F5DC)],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.picture_pdf, size: 48, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(
                        'Template PDF requis\nassets/templates/template_vierge.pdf',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: w * 0.025, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Date (bandeau bleu) ──
              _overlay(
                AppConstants.dateZone, w, h,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.008),
                  decoration: BoxDecoration(
                    color: AppConstants.blueLogo,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '> ${Formatters.formatDate(event.date)} >',
                    style: TextStyle(
                      fontFamily: AppConstants.fontBody,
                      fontSize: w * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // ── Lieu ──
              _overlayText(
                AppConstants.locationZone, w, h,
                event.location,
                fontSize: w * 0.05, bold: true,
              ),

              // ── Type d'événement ──
              _overlayText(
                AppConstants.eventTypeZone, w, h,
                event.eventType,
                fontSize: w * 0.035, bold: true,
              ),

              // ── Public ──
              _overlayText(
                AppConstants.audienceZone, w, h,
                event.audience,
                fontSize: w * 0.035, bold: true,
              ),

              // ── Créneau horaire ──
              _overlayText(
                AppConstants.timeSlotZone, w, h,
                event.timeSlotText,
                fontSize: w * 0.035, bold: false,
              ),

              // ── Inscription (bas gauche) ──
              _overlay(
                AppConstants.registrationZone, w, h,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Inscription conseillée sur',
                        style: TextStyle(fontFamily: AppConstants.fontBody, fontSize: w * 0.026, color: AppConstants.black)),
                    Text(event.registrationUrl,
                        style: TextStyle(fontFamily: AppConstants.fontBody, fontSize: w * 0.032, fontWeight: FontWeight.bold, color: AppConstants.blueLogo)),
                  ],
                ),
              ),

              // ── Téléphones ──
              _overlay(
                AppConstants.phoneZone, w, h,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Informations au',
                        style: TextStyle(fontFamily: AppConstants.fontBody, fontSize: w * 0.026, color: AppConstants.black)),
                    Text(event.phoneText,
                        style: TextStyle(fontFamily: AppConstants.fontBody, fontSize: w * 0.028, fontWeight: FontWeight.bold, color: AppConstants.black)),
                  ],
                ),
              ),

              // ── QR code (bas droite) ──
              _overlay(
                AppConstants.qrZone, w, h,
                QrImageView(
                  data: Formatters.normalizeUrl(event.registrationUrl),
                  size: w * 0.18,
                  backgroundColor: Colors.white,
                ),
              ),

              // ── "Scannez…" ──
              _overlayText(
                AppConstants.scanTextZone, w, h,
                AppConstants.scanText,
                fontSize: w * 0.024, bold: false,
              ),
            ],
          );
        },
      ),
    );
  }

  /// Positionne un widget à une zone.
  Positioned _overlay(Zone zone, double w, double h, Widget child) {
    final x = _zoneX(zone, w);
    final y = zone.topY * h / 100;
    final zoneW = zone.widthPct * w / 100;

    return Positioned(top: y, left: x, width: zoneW, child: child);
  }

  /// Positionne un texte à une zone.
  Positioned _overlayText(Zone zone, double w, double h, String text,
      {required double fontSize, required bool bold}) {
    final x = _zoneX(zone, w);
    final y = zone.topY * h / 100;
    final zoneW = zone.widthPct * w / 100;

    TextAlign align;
    switch (zone.align) {
      case ZoneAlign.left:
        align = TextAlign.left;
        break;
      case ZoneAlign.right:
        align = TextAlign.right;
        break;
      case ZoneAlign.center:
        align = TextAlign.center;
        break;
    }

    return Positioned(
      top: y,
      left: x,
      width: zoneW,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontFamily: AppConstants.fontBody,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: AppConstants.black,
        ),
      ),
    );
  }

  double _zoneX(Zone zone, double w) {
    switch (zone.align) {
      case ZoneAlign.center:
        final centerX = zone.centerX ?? 50;
        return (centerX - zone.widthPct / 2) * w / 100;
      case ZoneAlign.left:
        return (zone.leftX ?? 0) * w / 100;
      case ZoneAlign.right:
        final rightX = zone.rightX ?? 100;
        return (rightX - zone.widthPct) * w / 100;
    }
  }
}
