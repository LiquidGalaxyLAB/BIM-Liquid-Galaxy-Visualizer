import 'package:bim_visualizer_flutter/data/repositories/preferences_repository.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

void main () {
  test('When no values are set, the default values should be returned', () async {
    // given
    SharedPreferences.setMockInitialValues({});

    // when
    final preferencesRepo = PreferencesRepository(await SharedPreferences.getInstance());
    final prefs = preferencesRepo.get();

    // then
    expect(prefs, Server.defaultValues());
  });

  test('When values are set, the values should be returned', () async {
    // given
    const savedPrefs = Server(
      hostname: 'lg',
      ipAddress: '127.0.0.1',
      password: 'lq'
    );

    SharedPreferences.setMockInitialValues({
      PreferencesRepository.prefsKey: jsonEncode(savedPrefs.toJson())
    });

    // when
    final preferencesRepo = PreferencesRepository(await SharedPreferences.getInstance());
    final prefs = preferencesRepo.get();

    // then
    expect(prefs, savedPrefs);
  });
}