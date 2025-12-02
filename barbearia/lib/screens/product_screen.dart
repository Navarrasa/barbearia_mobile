import 'package:flutter/material.dart';
import '../services/cutSearch.dart';
import '../models/service_model.dart';
import 'appointment_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cortes Disponíveis")),

      body: FutureBuilder<List<ServiceModel>>(
        future: CutsService().getCortes(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar cortes"));
          }

          final cortes = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cortes.length,
            itemBuilder: (context, i) {
              final c = cortes[i];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: Image.network(
                    c.imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(c.title),
                  subtitle: Text("R\$ ${c.price.toStringAsFixed(2)}"),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AppointmentScreen(service: c),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
