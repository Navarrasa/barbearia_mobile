import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../models/service_model.dart';
import '../models/appointment_model.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Box servicesBox = Hive.box('servicesBox');
  final Box appointmentsBox = Hive.box('appointmentsBox');
  final Uuid _uuid = const Uuid();

  // Services
  Future<List<ServiceModel>> fetchServices() async {
    try {
      final snapshot = await _db.collection('services').get();
      final services = snapshot.docs.map((d) => ServiceModel.fromMap(d.data(), d.id)).toList();
      // cache locally
      servicesBox.put('services', snapshot.docs.map((d) => {...d.data(), 'id': d.id}).toList());
      return services;
    } catch (e) {
      // fallback to local cache
      final cached = servicesBox.get('services', defaultValue: []);
      return (cached as List).map((m) => ServiceModel.fromMap(Map<String, dynamic>.from(m), m['id'])).toList();
    }
  }

  // Add appointment (FireStore + local cache)
  Future<void> addAppointment(AppointmentModel appt) async {
    final id = _uuid.v4();
    final data = appt.toMap();
    try {
      await _db.collection('appointments').doc(id).set(data);
      // cache
      final cached = List.from(appointmentsBox.get('appointments', defaultValue: []));
      cached.add({...data, 'id': id});
      appointmentsBox.put('appointments', cached);
    } catch (e) {
      // offline: store in local box but mark pending
      final cached = List.from(appointmentsBox.get('appointments', defaultValue: []));
      cached.add({...data, 'id': id, 'pending': true});
      appointmentsBox.put('appointments', cached);
    }
  }

  // synchronize pending appointments when online
  Future<void> syncPendingAppointments() async {
    final cached = List.from(appointmentsBox.get('appointments', defaultValue: []));
    final pending = cached.where((e) => e['pending'] == true).toList();
    for (var p in pending) {
      try {
        final id = p['id'];
        final copy = Map<String, dynamic>.from(p);
        copy.remove('pending');
        await _db.collection('appointments').doc(id).set(copy);
        p.remove('pending');
      } catch (_) {
        // keep pending
      }
    }
    appointmentsBox.put('appointments', cached);
  }
}
