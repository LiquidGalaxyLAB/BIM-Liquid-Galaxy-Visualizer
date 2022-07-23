import 'package:bim_visualizer_flutter/data/repositories/preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NodeAPIProvider {
  late PreferencesRepository _preferencesRepo;

  Future<List<dynamic>> getAll(http.Client client) async {
    final prefs = await SharedPreferences.getInstance();
    _preferencesRepo = PreferencesRepository(prefs);
    final preferences = _preferencesRepo.get();
    
    final baseUrl = 'http://' + preferences.ipAddress! + ':3210/';
    final response = await client.get(Uri.parse(baseUrl + 'bim/'));
    if (response.statusCode != 200) {
      throw Exception('Failed to get data');
    }
    return json.decode(response.body)['values'] as List<dynamic>;
  }
}