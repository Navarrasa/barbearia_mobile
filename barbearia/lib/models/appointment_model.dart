class AppointmentModel {
  final String id;
  final String serviceId;
  final String clientName;
  final DateTime datetime;
  final String? notes;

  AppointmentModel({
    required this.id,
    required this.serviceId,
    required this.clientName,
    required this.datetime,
    this.notes,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map, String id) {
    return AppointmentModel(
      id: id,
      serviceId: map['serviceId'] ?? '',
      clientName: map['clientName'] ?? '',
      datetime: DateTime.parse(map['datetime']),
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() => {
        'serviceId': serviceId,
        'clientName': clientName,
        'datetime': datetime.toIso8601String(),
        'notes': notes,
      };
}
