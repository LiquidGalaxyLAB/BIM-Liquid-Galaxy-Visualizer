import 'package:bim_visualizer_flutter/data/repositories/galaxy_repository.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartssh2/dartssh2.dart';

// honeypot.terminal.studio.2022 honeypot that accepts all passwords and public-keys
// honeypot.terminal.studio.2023 honeypot that denies all passwords and public-keys
void main () {
  test('When credentials are valid, should establish a connection', () async {
    // given
    Server server = getTestServer();
    const port = 2022;

    // when
    final galaxyRepo = GalaxyRepository();
    final client = await galaxyRepo.connect(server, port);

    // then
    client.fold(
      (l) {
        fail('Should have connect');
      },
      (r) {
        r.close();
      }
    );
  });

  test('When credentials are invalid, should throw SSHAuthFailError', () async {
    // given
    Server server = getTestServer();
    const port = 2023;

    // when
    final galaxyRepo = GalaxyRepository();
    final client = await galaxyRepo.connect(server, port);

    // then
    client.fold(
      (l) {
        expect(l, isA<SSHAuthFailError>());
      },
      (r) {
        r.close();
        fail('Should have throw');
      }
    );
  });

  test('On close, should close client connection', () async {
    // given
    Server server = getTestServer();
    const port = 2022;

    final galaxyRepo = GalaxyRepository();
    final client = await galaxyRepo.connect(server, port);

    // when
    client.fold(
      (l) {
        fail('Should have connect');
      },
      (r) async {
        final closed = await galaxyRepo.close(r);

        // then
        expect(closed.isClosed, true);
      }
    );
  });
}

Server getTestServer() {
  return const Server(
    hostname: 'root',
    ipAddress: 'honeypot.terminal.studio',
    password: 'random'
  );
}