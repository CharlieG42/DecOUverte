import 'dart:typed_data';
import 'package:pretty_qr/pretty_qr.dart';

class QrGenerator {
  QrGenerator._();

  /// Génère un QR code sous forme de bytes PNG (pour le PDF).
  static Future<Uint8List> generatePng(String data, {int size = 512}) async {
    final qrCode = QrCode.fromData(data: data);
    final qrImage = QrImage(qrCode);
    final bytes = await qrImage.toImageAsBytes(
      size: size,
      decoration: const QrDecoration(),
    );
    return bytes.bytes;
  }
}
