import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditAppointmentScreen extends StatefulWidget {
  final DocumentSnapshot doc;

  const EditAppointmentScreen({super.key, required this.doc});

  @override
  State<EditAppointmentScreen> createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  late TextEditingController serviceCtrl;
  late TextEditingController dateCtrl;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    final data = widget.doc.data() as Map<String, dynamic>;

    serviceCtrl = TextEditingController(text: data["serviceName"]);

    // TRATAR STRING ou TIMESTAMP
    if (data["date"] is Timestamp) {
      selectedDate = (data["date"] as Timestamp).toDate();
    } else if (data["date"] is String) {
      selectedDate = DateTime.tryParse(data["date"]);
    }

    dateCtrl = TextEditingController(
      text: selectedDate != null ? selectedDate!.toString().split(" ")[0] : "",
    );
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateCtrl.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> save() async {
    if (selectedDate == null) return;

    await widget.doc.reference.update({
      "serviceName": serviceCtrl.text,
      "date": Timestamp.fromDate(selectedDate!), // SALVA CORRETAMENTE
    });

    Navigator.pop(context);
  }

  Future<void> delete() async {
    await widget.doc.reference.delete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Agendamento")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: serviceCtrl,
              decoration: const InputDecoration(
                labelText: "Serviço",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: dateCtrl,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Data",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: pickDate,
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: save,
              child: const Text("Salvar"),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: delete,
              child: const Text(
                "Excluir Agendamento",
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}
