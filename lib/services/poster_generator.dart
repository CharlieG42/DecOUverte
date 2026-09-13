import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../constants.dart';
import '../models/event_data.dart';
import '../utils/formatters.dart';
import 'qr_generator.dart';
import 'template_renderer.dart';

class PosterGenerator {
  PosterGenerator._();

  /// Génère le PDF de l'affiche A4 portrait :
  /// 1. Rend le template vierge en image haute résolution
  /// 2. L'utilise comme fond pleine page
  /// 3. Overlay les 7 zones éditables + QR code
  static Future<String> generate(EventData event, String outputDir) async {
    final pdf = pw.Document();

    // Rendu du template en image
    final templateBytes = await TemplateRenderer.renderTemplatePng(dpi: 300);

    // Polices pour l'overlay
    final nunitoBold = await _loadFont('fonts/Nunito-Bold.ttf');
    final nunitoRegular = await _loadFont('fonts/Nunito-Regular.ttf');

    // QR code
    final qrBytes = await QrGenerator.generatePng(
      Formatters.normalizeUrl(event.registrationUrl),
    );

    final pageWidth = AppConstants.posterWidthMm * AppConstants.mmToPt;
    final pageHeight = AppConstants.posterHeightMm * AppConstants.mmToPt;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(pageWidth, pageHeight, marginAll: 0),
        build: (context) => pw.Stack(
          children: [
            // ── Fond : image du template vierge, pleine page ──
            pw.Positioned(
              top: 0,
              left: 0,
              child: pw.Image(
                pw.MemoryImage(templateBytes),
                width: pageWidth,
                height: pageHeight,
                fit: pw.BoxFit.fill,
              ),
            ),

            // ── Date (bandeau bleu) ──
            _overlayZone(
              AppConstants.dateZone,
              pageWidth,
              pageHeight,
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(AppConstants.blueLogo.value),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(
                  '> ${Formatters.formatDate(event.date)} >',
                  style: pw.TextStyle(
                    font: nunitoBold,
                    fontSize: 22,
                    color: PdfColors.white,
                  ),
                ),
              ),
              align: pw.TextAlign.center,
            ),

            // ── Lieu ──
            _overlayText(
              AppConstants.locationZone,
              pageWidth,
              pageHeight,
              event.location,
              nunitoBold,
              18,
              AppConstants.black,
            ),

            // ── Type d'événement ──
            _overlayText(
              AppConstants.eventTypeZone,
              pageWidth,
              pageHeight,
              event.eventType,
              nunitoBold,
              13,
              AppConstants.black,
            ),

            // ── Public concerné ──
            _overlayText(
              AppConstants.audienceZone,
              pageWidth,
              pageHeight,
              event.audience,
              nunitoBold,
              13,
              AppConstants.black,
            ),

            // ── Créneau horaire ──
            _overlayText(
              AppConstants.timeSlotZone,
              pageWidth,
              pageHeight,
              event.timeSlotText,
              nunitoRegular,
              13,
              AppConstants.black,
            ),

            // ── Inscription (bas gauche) ──
            _overlayZone(
              AppConstants.registrationZone,
              pageWidth,
              pageHeight,
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Inscription conseillée sur',
                      style: pw.TextStyle(font: nunitoRegular, fontSize: 10)),
                  pw.Text(event.registrationUrl,
                      style: pw.TextStyle(
                          font: nunitoBold,
                          fontSize: 12,
                          color: PdfColor.fromInt(AppConstants.blueLogo.value))),
                ],
              ),
              align: pw.TextAlign.left,
            ),

            // ── Téléphones (bas gauche, sous inscription) ──
            _overlayZone(
              AppConstants.phoneZone,
              pageWidth,
              pageHeight,
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Informations au',
                      style: pw.TextStyle(font: nunitoRegular, fontSize: 10)),
                  pw.Text(event.phoneText,
                      style: pw.TextStyle(font: nunitoBold, fontSize: 11)),
                ],
              ),
              align: pw.TextAlign.left,
            ),

            // ── QR code (bas droite) ──
            _overlayZone(
              AppConstants.qrZone,
              pageWidth,
              pageHeight,
              pw.Image(pw.MemoryImage(qrBytes), width: 80, height: 80),
              align: pw.TextAlign.center,
            ),

            // ── Texte "Scannez…" (sous QR) ──
            _overlayText(
              AppConstants.scanTextZone,
              pageWidth,
              pageHeight,
              AppConstants.scanText,
              nunitoRegular,
              9,
              AppConstants.black,
            ),
          ],
        ),
      ),
    );

    final safeLoc = event.location.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    final fileName =
        'affiche_${event.date.year}${event.date.month.toString().padLeft(2, '0')}${event.date.day.toString().padLeft(2, '0')}_$safeLoc.pdf';
    final outputPath = '$outputDir/$fileName';
    final file = File(outputPath);
    await file.writeAsBytes(await pdf.save());
    return outputPath;
  }

  /// Positionne un widget à une zone donnée.
  static pw.Positioned _overlayZone(
    Zone zone,
    double pageW,
    double pageH,
    pw.Widget child, {
    pw.TextAlign align = pw.TextAlign.center,
  }) {
    final x = _zoneX(zone, pageW);
    final y = zone.topY * pageH / 100;
    final w = zone.widthPct * pageW / 100;

    return pw.Positioned(
      top: y,
      left: x,
      width: w,
      child: child,
    );
  }

  /// Positionne un texte à une zone donnée.
  static pw.Positioned _overlayText(
    Zone zone,
    double pageW,
    double pageH,
    String text,
    pw.Font font,
    double fontSize,
    Color color, {
    pw.TextAlign textAlign = pw.TextAlign.center,
  }) {
    final x = _zoneX(zone, pageW);
    final y = zone.topY * pageH / 100;
    final w = zone.widthPct * pageW / 100;

    pw.TextAlign align;
    switch (zone.align) {
      case ZoneAlign.left:
        align = pw.TextAlign.left;
        break;
      case ZoneAlign.right:
        align = pw.TextAlign.right;
        break;
      case ZoneAlign.center:
        align = pw.TextAlign.center;
        break;
    }

    return pw.Positioned(
      top: y,
      left: x,
      width: w,
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          font: font,
          fontSize: fontSize,
          color: PdfColor.fromInt(color.value),
        ),
      ),
    );
  }

  /// Calcule la position X (bord gauche) selon le type d'alignement de la zone.
  static double _zoneX(Zone zone, double pageW) {
    switch (zone.align) {
      case ZoneAlign.center:
        final centerX = zone.centerX ?? 50;
        return (centerX - zone.widthPct / 2) * pageW / 100;
      case ZoneAlign.left:
        return (zone.leftX ?? 0) * pageW / 100;
      case ZoneAlign.right:
        final rightX = zone.rightX ?? 100;
        return (rightX - zone.widthPct) * pageW / 100;
    }
  }

  static Future<pw.Font> _loadFont(String path) async {
    final byteData = await rootBundle.load(path);
    return pw.Font.ttf(byteData);
  }
}
