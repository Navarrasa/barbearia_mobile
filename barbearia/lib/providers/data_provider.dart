import 'package:flutter/material.dart';
import '../../models/service_model.dart';
import '../../models/appointment_model.dart';
import '../../services/firestore_service.dart';

class DataProvider extends ChangeNotifier {
  final FirestoreService _fs = FirestoreService();
  List<ServiceModel> services = [];
  List<AppointmentModel> appointments = [];

  bool loading = false;

  Future<void> loadServices() async {
    loading = true;
    notifyListeners();
    services = await _fs.fetchServices();
    loading = false;
    notifyListeners();
  }

  Future<void> addAppointment(AppointmentModel appt) async {
    await _fs.addAppointment(appt);
    await loadAppointments();
  }

  Future<void> loadAppointments() async {
    // basic: read from local cache box, convert to models
    final box = _fs.appointmentsBox;
    final cached = List.from(box.get('appointments', defaultValue: []));
    appointments = cached.map((m) {
      return AppointmentModel.fromMap(Map<String, dynamic>.from(m), m['id']);
    }).toList();
    notifyListeners();
  }

  Future<void> syncPending() => _fs.syncPendingAppointments();
}
