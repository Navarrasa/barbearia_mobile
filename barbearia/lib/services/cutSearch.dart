import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service_model.dart';

class CutsService {
  final String url = "https://navarrasa.github.io/barber_get_api/barber.json";

  Future<List<ServiceModel>> getCortes() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> list = json.decode(response.body);
      return list.map((e) => ServiceModel.fromMap(e, e['id'].toString())).toList();
    } else {
      throw Exception("Falha ao carregar dados dos cortes");
      }
    }
  }
