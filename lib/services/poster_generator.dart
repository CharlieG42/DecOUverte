import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../constants.dart';
import '../models/event_data.dart';
import '../utils/formatters.dart';
import 'qr_generator.dart';

class PosterGenerator {
  PosterGenerator._();

  /// Génère le PDF de l'affiche A4 portrait et le sauvegarde sur disque.
  /// Retourne le chemin du fichier PDF créé.
  static Future<String> generate(EventData event, String outputDir) async {
    final pdf = pw.Document();

    final logoBytes = await _loadAsset(AppConstants.assetLogo);
    final bgBytes = await _loadAsset(AppConstants.assetBackground);
    final compassBytes = await _loadAsset(AppConstants.assetCompass);

    final comfortaaBold = await _loadFont('fonts/Comfortaa-Bold.ttf');
    final nunitoBold = await _loadFont('fonts/Nunito-Bold.ttf');
    final nunitoRegular = await _loadFont('fonts/Nunito-Regular.ttf');

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
            // Fond dégradé
            pw.Container(
              width: pageWidth,
              height: pageHeight,
              decoration: pw.BoxDecoration(
                gradient: pw.LinearGradient(
                  begin: pw.Alignment.topCenter,
                  end: pw.Alignment.bottomCenter,
                  colors: [
                    PdfColor.fromInt(AppConstants.bgTop.value),
                    PdfColor.fromInt(AppConstants.bgBottom.value),
                  ],
                ),
              ),
            ),
            // Image de fond (silhouettes)
            pw.Positioned(
              top: pageHeight * 0.15,
              left: 0,
              right: 0,
              child: pw.Center(
                child: pw.Image(
                  pw.MemoryImage(bgBytes),
                  width: pageWidth * 0.8,
                  height: pageHeight * 0.25,
                  fit: pw.BoxFit.contain,
                ),
              ),
            ),
            // Logo
            pw.Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: pw.Center(
                child: pw.Image(
                  pw.MemoryImage(logoBytes),
                  width: pageWidth * 0.35,
                  height: 120,
                  fit: pw.BoxFit.contain,
                ),
              ),
            ),
            // Boussole
            pw.Positioned(
              top: pageHeight * 0.40,
              left: 0,
              right: 0,
              child: pw.Center(
                child: pw.Image(
                  pw.MemoryImage(compassBytes),
                  width: pageWidth * 0.25,
                  height: pageWidth * 0.25,
                  fit: pw.BoxFit.contain,
                ),
              ),
            ),
            // Titre
            pw.Positioned(
              top: pageHeight * 0.32,
              left: 0,
              right: 0,
              child: pw.Center(
                child: pw.Text(
                  AppConstants.titleText,
                  style: pw.TextStyle(
                    font: comfortaaBold,
                    fontSize: 48,
                    color: PdfColor.fromInt(AppConstants.black.value),
                  ),
                ),
              ),
            ),
            // Accroche
            pw.Positioned(
              top: pageHeight * 0.38,
              left: pageWidth * 0.1,
              right: pageWidth * 0.1,
              child: pw.Center(
                child: pw.Text(
                  AppConstants.subtitleText,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: nunitoBold,
                    fontSize: 11,
                    color: PdfColor.fromInt(AppConstants.black.value),
                  ),
                ),
              ),
            ),
            // Date
            pw.Positioned(
              top: pageHeight * 0.55,
              left: 0,
              right: 0,
              child: pw.Center(
                child: pw.Container(
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
              ),
            ),
            // Lieu
            pw.Positioned(
              top: pageHeight * 0.60,
              left: 0,
              right: 0,
              child: pw.Center(
                child: pw.Text(
                  event.location,
                  style: pw.TextStyle(
                    font: nunitoBold,
                    fontSize: 18,
                    color: PdfColor.fromInt(AppConstants.black.value),
                  ),
                ),
              ),
            ),
            // Infos
            pw.Positioned(
              top: pageHeight * 0.66,
              left: pageWidth * 0.08,
              right: pageWidth * 0.08,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(event.eventType,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(font: nunitoBold, fontSize: 13)),
                  pw.SizedBox(height: 6),
                  pw.Text(event.audience,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(font: nunitoBold, fontSize: 13)),
                  pw.SizedBox(height: 6),
                  pw.Text(event.timeSlotText,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(font: nunitoRegular, fontSize: 13)),
                ],
              ),
            ),
            // Inscription + téléphones
            pw.Positioned(
              bottom: 40,
              left: pageWidth * 0.08,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Inscription conseillée sur',
                      style: pw.TextStyle(font: nunitoRegular, fontSize: 10)),
                  pw.Text(event.registrationUrl,
                      style: pw.TextStyle(
                          font: nunitoBold,
                          fontSize: 12,
                          color: PdfColor.fromInt(AppConstants.blueLogo.value))),
                  pw.SizedBox(height: 8),
                  pw.Text('Informations au',
                      style: pw.TextStyle(font: nunitoRegular, fontSize: 10)),
                  pw.Text(event.phoneText,
                      style: pw.TextStyle(font: nunitoBold, fontSize: 11)),
                ],
              ),
            ),
            // QR code
            pw.Positioned(
              bottom: 40,
              right: pageWidth * 0.08,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Image(pw.MemoryImage(qrBytes), width: 80, height: 80),
                  pw.SizedBox(height: 6),
                  pw.Text(AppConstants.scanText,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(font: nunitoRegular, fontSize: 9)),
                ],
              ),
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

  static Future<Uint8List> _loadAsset(String path) async {
    final byteData = await rootBundle.load(path);
    return byteData.buffer.asUint8List();
  }

  static Future<pw.Font> _loadFont(String path) async {
    final byteData = await rootBundle.load(path);
    return pw.Font.ttf(byteData);
  }
}
