import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdfrx/pdfrx.dart' as pdfrx;
import 'dart:ui' as ui;

/// Rend le PDF template vierge en image haute résolution.
///
/// Utilise pdfrx (déjà utilisé dans OWildZimut) pour charger le PDF
/// et le rasteriser en image utilisable comme fond de l'affiche.
class TemplateRenderer {
  TemplateRenderer._();

  /// Charge le PDF template depuis les assets et rend la page 1 en image.
  /// [dpi] contrôle la résolution de sortie (300 = qualité print).
  static Future<Uint8List> renderTemplatePng({int dpi = 300}) async {
    // Chargement du PDF depuis les assets
    final pdfData = await rootBundle.load(AppConstants.templatePath);
    final pdfBytes = pdfData.buffer.asUint8List();

    // Création d'un fichier temporaire car pdfrx a besoin d'un chemin
    // Note: en production, utiliser path_provider pour le temp dir
    final doc = await pdfrx.PdfDocument.openData(pdfBytes);

    // Rendu de la page 1
    final page = await doc.getPage(1);
    final render = await page.render(
      dpi: dpi.toDouble(),
    );

    final image = await render.createImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    page.dispose();

    return byteData!.buffer.asUint8List();
  }
}
