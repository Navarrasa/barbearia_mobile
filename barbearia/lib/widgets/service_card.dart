// widgets/service_card.dart
import 'package:flutter/material.dart';
import '../models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;
  const ServiceCard({required this.service, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(service.title),
        subtitle: Text(service.description),
        trailing: Text('R\$ ${service.price.toStringAsFixed(2)}'),
        onTap: onTap,
      ),
    );
  }
}
