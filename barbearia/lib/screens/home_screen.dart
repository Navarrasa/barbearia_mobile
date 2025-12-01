// screens/home_screen.dart (resumido)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../../widgets/service_card.dart';
import 'appointment_screen.dart';

class HomeScreen extends StatefulWidget { const HomeScreen({super.key}); @override State<HomeScreen> createState() => _HomeScreenState(); }

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final dp = Provider.of<DataProvider>(context, listen: false);
    dp.loadServices();
    dp.loadAppointments();
    dp.syncPending();
  }

  @override
  Widget build(BuildContext context) {
    final dp = Provider.of<DataProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Studio Pro Barber')),
      body: dp.loading ? const Center(child: CircularProgressIndicator()) : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          const Text('Nossos serviços', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...dp.services.map((s) => ServiceCard(service: s, onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => AppointmentScreen(service: s)));
          })),
        ],
      ),
    );
  }
}
