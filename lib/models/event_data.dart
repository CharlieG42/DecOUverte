/// Données éditables d'un événement — sérialisable en JSON.
class EventData {
  EventData({
    required this.date,
    this.timeSlotLabel = 'Horaire libre',
    this.startTime,
    this.endTime,
    required this.location,
    required this.eventType,
    required this.audience,
    required this.registrationUrl,
    required this.phoneNumbers,
  });

  final DateTime date;
  final String timeSlotLabel;
  final String? startTime;
  final String? endTime;
  final String location;
  final String eventType;
  final String audience;
  final String registrationUrl;
  final List<String> phoneNumbers;

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'timeSlotLabel': timeSlotLabel,
        'startTime': startTime,
        'endTime': endTime,
        'location': location,
        'eventType': eventType,
        'audience': audience,
        'registrationUrl': registrationUrl,
        'phoneNumbers': phoneNumbers,
      };

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
        date: DateTime.parse(json['date'] as String),
        timeSlotLabel: json['timeSlotLabel'] as String? ?? 'Horaire libre',
        startTime: json['startTime'] as String?,
        endTime: json['endTime'] as String?,
        location: json['location'] as String,
        eventType: json['eventType'] as String,
        audience: json['audience'] as String,
        registrationUrl: json['registrationUrl'] as String,
        phoneNumbers:
            (json['phoneNumbers'] as List<dynamic>).cast<String>(),
      );

  String get timeSlotText {
    if (startTime != null && endTime != null) {
      return '$timeSlotLabel\nde $startTime à $endTime';
    }
    return timeSlotLabel;
  }

  String get phoneText {
    if (phoneNumbers.length == 1) return phoneNumbers.first;
    if (phoneNumbers.length == 2) return '${phoneNumbers[0]}\nou au ${phoneNumbers[1]}';
    return phoneNumbers.join('\n');
  }

  EventData copyWith({
    DateTime? date,
    String? timeSlotLabel,
    String? startTime,
    String? endTime,
    String? location,
    String? eventType,
    String? audience,
    String? registrationUrl,
    List<String>? phoneNumbers,
  }) =>
      EventData(
        date: date ?? this.date,
        timeSlotLabel: timeSlotLabel ?? this.timeSlotLabel,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        location: location ?? this.location,
        eventType: eventType ?? this.eventType,
        audience: audience ?? this.audience,
        registrationUrl: registrationUrl ?? this.registrationUrl,
        phoneNumbers: phoneNumbers ?? this.phoneNumbers,
      );
}
