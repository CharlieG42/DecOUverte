import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/event_data.dart';
import '../services/poster_generator.dart';
import '../widgets/poster_canvas.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key, required this.event});

  final EventData event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aperçu de l\'affiche')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(elevation: 8, child: PosterCanvas(event: event)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                onPressed: () => _generatePdf(context),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Générer PDF'),
              ),
              FilledButton.icon(
                onPressed: () => _generateAndShare(context),
                icon: const Icon(Icons.share),
                label: const Text('Générer & Partager'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = await PosterGenerator.generate(event, dir.path);
      messenger.showSnackBar(SnackBar(content: Text('Affiche générée : $path')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }

  Future<void> _generateAndShare(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = await PosterGenerator.generate(event, dir.path);
      await Share.shareXFiles([XFile(path)], text: 'Affiche DéCOuverte — ${event.location}');
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }
}
