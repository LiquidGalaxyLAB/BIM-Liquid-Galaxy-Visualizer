import 'dart:convert';

import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferencesRepositoryImpl {
  Server get();
  Future<void> set(Server server);
  Future<void> clear();
}

class PreferencesRepository implements PreferencesRepositoryImpl {
  static const prefsKey = 'prefs';

  final SharedPreferences _sharedPreferences;

  PreferencesRepository(this._sharedPreferences);

  @override
  Future<void> clear() async => _sharedPreferences.clear();

  @override
  Server get() {
    final data = _sharedPreferences.getString(prefsKey);
    if (data == null) {
      return Server.defaultValues();
    }

    final map = Map<String, dynamic>.from(jsonDecode(data));
    return Server.fromJson(map);
  }

  @override
  Future<void> set(Server server) async {
    final data = jsonEncode(server.toJson());
    await _sharedPreferences.setString(prefsKey, data);
  }
}