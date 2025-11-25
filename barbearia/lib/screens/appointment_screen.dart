import 'package:barbearia/models/service_model.dart';
import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  final ServiceModel service;
  
  const AppointmentScreen({
    super.key, 
    required this.service 
  });

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final serviceController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final notesController = TextEditingController();

  /// Seleciona data
  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  /// Seleciona horário
  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  /// Salva o agendamento
  void _saveAppointment() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Escolha uma data e horário")),
      );
      return;
    }

    // 🔥 AQUI você enviaria para o Firestore:
    // FirebaseFirestore.instance.collection("appointments").add({...})

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Agendamento criado com sucesso!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agendar Horário"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nome do cliente"),
                validator: (v) =>
                    v!.isEmpty ? "Informe o nome do cliente" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: serviceController,
                decoration: const InputDecoration(labelText: "Serviço"),
                validator: (v) =>
                    v!.isEmpty ? "Informe o serviço desejado" : null,
              ),

              const SizedBox(height: 16),

              /// DATA
              ListTile(
                title: Text(
                  selectedDate == null
                      ? "Selecione a data"
                      : "Data: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: _pickDate,
              ),

              /// HORÁRIO
              ListTile(
                title: Text(
                  selectedTime == null
                      ? "Selecione o horário"
                      : "Horário: ${selectedTime!.format(context)}",
                ),
                trailing: const Icon(Icons.access_time),
                onTap: _pickTime,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: notesController,
                decoration:
                    const InputDecoration(labelText: "Observações (opcional)"),
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _saveAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Confirmar Agendamento",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
