import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  String formatDate(dynamic date) {
    if (date is Timestamp) {
      final d = date.toDate();
      return "${d.day.toString().padLeft(2, '0')}/"
            "${d.month.toString().padLeft(2, '0')}/"
            "${d.year}";
    }

    if (date is String) {
      // caso esteja salvo como ISO8601 (2025-12-03T00:00:00.000)
      final d = DateTime.tryParse(date);
      if (d != null) {
        return "${d.day.toString().padLeft(2, '0')}/"
              "${d.month.toString().padLeft(2, '0')}/"
              "${d.year}";
      }
    }

    return date.toString();
  }

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
        title: Text(auth.isAdmin ? "Todos os Agendamentos" : "Meus Agendamentos"),
      ),

      body: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return Center(
              child: Text(
                auth.isAdmin
                    ? "Nenhum agendamento encontrado."
                    : "Você ainda não fez nenhum agendamento.",
              ),
            );
          }

          final docs = snap.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(data["serviceName"]),
                  subtitle: Text(formatDate(data["date"])),

                  onTap: auth.isAdmin
                      ? () {
                          Navigator.pushNamed(
                            context,
                            "/editAppointment",
                            arguments: doc,
                          );
                        }
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
