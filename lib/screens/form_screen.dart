import 'package:flutter/material.dart';
import '../models/event_data.dart';
import 'preview_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _date;
  late TimeOfDay? _startTime;
  late TimeOfDay? _endTime;
  late TextEditingController _locationController;
  late TextEditingController _eventTypeController;
  late TextEditingController _audienceController;
  late TextEditingController _urlController;
  late TextEditingController _phone1Controller;
  late TextEditingController _phone2Controller;

  @override
  void initState() {
    super.initState();
    _date = DateTime(2026, 10, 4);
    _startTime = const TimeOfDay(hour: 9, minute: 30);
    _endTime = const TimeOfDay(hour: 12, minute: 0);
    _locationController = TextEditingController(text: 'SAINT-HAON-LE-CHÂTEL');
    _eventTypeController = TextEditingController(text: 'Circuits urbains\nde débutants à confirmés');
    _audienceController = TextEditingController(text: 'Circuit enfants\nà partir de 4 ans');
    _urlController = TextEditingController(text: 'www.crra.run');
    _phone1Controller = TextEditingController(text: '07.79.61.34.45');
    _phone2Controller = TextEditingController(text: '06.86.57.76.22');
  }

  @override
  void dispose() {
    _locationController.dispose();
    _eventTypeController.dispose();
    _audienceController.dispose();
    _urlController.dispose();
    _phone1Controller.dispose();
    _phone2Controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime(TimeOfDay? current, Function(TimeOfDay) onPicked) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: current ?? TimeOfDay.now(),
    );
    if (picked != null) onPicked(picked);
  }

  String _formatTime(TimeOfDay? t) {
    if (t == null) return '';
    return '${t.hour}h${t.minute.toString().padLeft(2, '0')}';
  }

  EventData _buildEventData() {
    final phones = [
      _phone1Controller.text.trim(),
      if (_phone2Controller.text.trim().isNotEmpty) _phone2Controller.text.trim(),
    ];
    return EventData(
      date: _date,
      startTime: _formatTime(_startTime),
      endTime: _formatTime(_endTime),
      location: _locationController.text.trim(),
      eventType: _eventTypeController.text.trim(),
      audience: _audienceController.text.trim(),
      registrationUrl: _urlController.text.trim(),
      phoneNumbers: phones,
    );
  }

  void _goToPreview() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewScreen(event: _buildEventData()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DéCOuverte — Nouvelle affiche')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _SectionLabel('Date de l\'événement'),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('${_date.day}/${_date.month}/${_date.year}', style: const TextStyle(fontSize: 16)),
              onTap: _pickDate,
            ),
            const Divider(),
            const _SectionLabel('Créneau horaire'),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(_startTime != null ? 'Début : ${_formatTime(_startTime)}' : 'Début'),
                    onTap: () => _pickTime(_startTime, (t) => setState(() => _startTime = t)),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(_endTime != null ? 'Fin : ${_formatTime(_endTime)}' : 'Fin'),
                    onTap: () => _pickTime(_endTime, (t) => setState(() => _endTime = t)),
                  ),
                ),
              ],
            ),
            const Divider(),
            const _SectionLabel('Lieu'),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(hintText: 'Nom du lieu'),
            ),
            const Divider(),
            const _SectionLabel('Type d\'événement'),
            TextFormField(
              controller: _eventTypeController,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'ex: Circuits urbains de débutants à confirmés'),
            ),
            const Divider(),
            const _SectionLabel('Public concerné'),
            TextFormField(
              controller: _audienceController,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'ex: Circuit enfants à partir de 4 ans'),
            ),
            const Divider(),
            const _SectionLabel('Lien d\'inscription'),
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(hintText: 'ex: www.crra.run', prefixText: 'https://'),
            ),
            const Divider(),
            const _SectionLabel('Contacts téléphoniques'),
            TextFormField(
              controller: _phone1Controller,
              decoration: const InputDecoration(labelText: 'Téléphone 1'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phone2Controller,
              decoration: const InputDecoration(labelText: 'Téléphone 2 (optionnel)'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToPreview,
        icon: const Icon(Icons.visibility),
        label: const Text('Aperçu'),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }
}
