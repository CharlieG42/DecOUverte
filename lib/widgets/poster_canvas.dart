import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../constants.dart';
import '../models/event_data.dart';
import '../utils/formatters.dart';

/// Rendu visuel de l'affiche — utilisé pour l'aperçu écran.
class PosterCanvas extends StatelessWidget {
  const PosterCanvas({
    super.key,
    required this.event,
    this.scale = 1.0,
  });

  final EventData event;
  final double scale;

  @override
  Widget build(BuildContext context) {
    const aspectRatio = 210.0 / 297.0;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppConstants.bgTop, AppConstants.bgBottom],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: h * 0.02,
                  left: w * 0.15,
                  right: w * 0.15,
                  child: Image.asset(AppConstants.assetLogo, fit: BoxFit.contain),
                ),
                Positioned(
                  top: h * 0.15,
                  left: w * 0.1,
                  right: w * 0.1,
                  child: Opacity(
                    opacity: 0.7,
                    child: Image.asset(AppConstants.assetBackground, fit: BoxFit.contain),
                  ),
                ),
                Positioned(
                  top: h * 0.40,
                  left: w * 0.3,
                  right: w * 0.3,
                  child: Image.asset(AppConstants.assetCompass, fit: BoxFit.contain),
                ),
                Positioned(
                  top: h * 0.32,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      AppConstants.titleText,
                      style: TextStyle(
                        fontFamily: AppConstants.fontTitle,
                        fontSize: w * 0.13,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: h * 0.38,
                  left: w * 0.1,
                  right: w * 0.1,
                  child: Center(
                    child: Text(
                      AppConstants.subtitleText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppConstants.fontBody,
                        fontSize: w * 0.028,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: h * 0.55,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.01),
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
                ),
                Positioned(
                  top: h * 0.60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      event.location,
                      style: TextStyle(
                        fontFamily: AppConstants.fontBody,
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: h * 0.66,
                  left: w * 0.08,
                  right: w * 0.08,
                  child: Column(
                    children: [
                      _infoText(event.eventType, w),
                      SizedBox(height: h * 0.01),
                      _infoText(event.audience, w),
                      SizedBox(height: h * 0.01),
                      _infoText(event.timeSlotText, w, bold: false),
                    ],
                  ),
                ),
                Positioned(
                  bottom: h * 0.03,
                  left: w * 0.06,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Inscription conseillée sur',
                          style: TextStyle(fontFamily: AppConstants.fontBody, fontSize: w * 0.026, color: AppConstants.black)),
                      Text(event.registrationUrl,
                          style: TextStyle(fontFamily: AppConstants.fontBody, fontSize: w * 0.032, fontWeight: FontWeight.bold, color: AppConstants.blueLogo)),
                      SizedBox(height: h * 0.01),
                      Text('Informations au',
                          style: TextStyle(fontFamily: AppConstants.fontBody, fontSize: w * 0.026, color: AppConstants.black)),
                      Text(event.phoneText,
                          style: TextStyle(fontFamily: AppConstants.fontBody, fontSize: w * 0.028, fontWeight: FontWeight.bold, color: AppConstants.black)),
                    ],
                  ),
                ),
                Positioned(
                  bottom: h * 0.03,
                  right: w * 0.06,
                  child: Column(
                    children: [
                      QrImageView(
                        data: Formatters.normalizeUrl(event.registrationUrl),
                        size: w * 0.22,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(height: h * 0.008),
                      Text(AppConstants.scanText,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: AppConstants.fontBody, fontSize: w * 0.024, color: AppConstants.black)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoText(String text, double w, {bool bold = true}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: AppConstants.fontBody,
        fontSize: w * 0.035,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: AppConstants.black,
      ),
    );
  }
}
