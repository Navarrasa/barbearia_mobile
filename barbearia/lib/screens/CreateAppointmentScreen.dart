import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/service_model.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class CreateAppointmentScreen extends StatefulWidget {
  final ServiceModel service;

  const CreateAppointmentScreen({super.key, required this.service});

  @override
  State<CreateAppointmentScreen> createState() => _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  DateTime? selectedDate;

  // 👉 Abrir seletor de data
  Future<void> pickDate() async {
    final picker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2100),
    );

    if (picker != null) {
      setState(() {
        selectedDate = picker;
      });
    }
  }

  // 👉 Criar agendamento no Firebase
  Future<void> createAppointment(AuthProvider auth) async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione uma data")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("appointments").add({
      "userId": auth.uid,
      "serviceId": widget.service.id,
      "serviceName": widget.service.nome,
      "date": Timestamp.fromDate(selectedDate!), // 👈 CORRETO!
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Criar Agendamento")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Escolha a Data:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickDate, // 👈 FUNCIONANDO AGORA
              child: Text(
                selectedDate == null
                    ? "Selecionar Data"
                    : "Selecionado: ${selectedDate!.toString().split(" ")[0]}",
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () => createAppointment(auth), // 👈 Salva corretamente
              child: const Text("Criar Agendamento"),
            ),
          ],
        ),
      ),
    );
  }
}
