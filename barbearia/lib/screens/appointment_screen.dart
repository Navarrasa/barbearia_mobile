import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class AppointmentScreen extends StatelessWidget {
  final dynamic service; // opcional — quando vem da ProductsScreen

  const AppointmentScreen({super.key, this.service});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    final stream = auth.isAdmin
        ? FirebaseFirestore.instance
            .collection("appointments")
            .orderBy("date")
            .snapshots()
        : FirebaseFirestore.instance
            .collection("appointments")
            .where("userId", isEqualTo: auth.uid)
            .orderBy("date")
            .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          auth.isAdmin ? "Todos os Agendamentos" : "Meus Agendamentos",
        ),
      ),

      body: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return Center(
              child: Text(auth.isAdmin
                  ? "Nenhum agendamento encontrado."
                  : "Você não tem agendamentos ainda."),
            );
          }

          final docs = snap.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final a = docs[index].data() as Map<String, dynamic>;
              final id = docs[index].id;

              final date = a["date"];
              final userId = a["userId"];
              final serviceName = a["serviceName"];

              return Card(
                child: ListTile(
                  title: Text(serviceName ?? "Serviço"),
                  subtitle: Text(date ?? "Sem data"),

                  trailing: auth.isAdmin
                      ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteAppointment(id),
                        )
                      : IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => editAppointment(context, id, date),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ADMIN remove
  Future<void> deleteAppointment(String id) async {
    await FirebaseFirestore.instance
        .collection("appointments")
        .doc(id)
        .delete();
  }

  // USER edita horário
  Future<void> editAppointment(
      BuildContext context, String id, String oldDate) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(oldDate),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (newDate == null) return;

    await FirebaseFirestore.instance
        .collection("appointments")
        .doc(id)
        .update({
      "date": newDate.toString(),
    });
  }
}
