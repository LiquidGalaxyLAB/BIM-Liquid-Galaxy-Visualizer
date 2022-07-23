import 'package:bim_visualizer_flutter/data/repositories/node_api_repository.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:bim_visualizer_flutter/data/models/bim_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'node_api_repository_test.mocks.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'dart:convert';

@GenerateMocks([http.Client])
void main() {
  final NodeAPIRepository _nodeAPIRepo = NodeAPIRepository();
  final Server server = Server.testValues();
  final mockHttp = MockClient();

  SharedPreferences.setMockInitialValues({ 'prefs': jsonEncode(server.toJson()) });

  test('When getting data, on success, should return a list', () async {
    // given
    Uri url = Uri.parse('http://localhost:3210/bim/');
    const String data = '{"values": []}';
    const int code = 200;

    // when
    when(mockHttp.get(url))
      .thenAnswer((_) async => http.Response(data, code));

    final result = await _nodeAPIRepo.getAll(mockHttp);

    // then
    result.fold(
      (l) {
        fail(l.toString());
      }, (r) {
        expect(r, isA<List<Bim>>());
      }
    );
  });

  test('When getting data, on error, should throw an exception', () async {
    // given
    Uri url = Uri.parse('http://localhost:3210/bim/');
    const String data = '{"values": []}';
    const int code = 400;
    
    // when
    when(mockHttp.get(url))
      .thenAnswer((_) async => http.Response(data, code));

    final result = await _nodeAPIRepo.getAll(mockHttp);

    // then
    result.fold(
      (l) {
        expect(l, isA<Exception>());
      }, (r) {
        fail('Should have throwed an exception');
      }
    );
  });
}