import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NodeAPIProvider {
  final baseUrl = dotenv.env['SERVER_URL'] ?? 'http://localhost:3210';

  Future<List<dynamic>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl + 'bim/'));
    if (response.statusCode != 200) {
      throw Exception('Failed to get data');
    }
    return json.decode(response.body)['values'] as List<dynamic>;
  }
}