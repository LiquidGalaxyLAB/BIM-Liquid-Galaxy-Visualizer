import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';

abstract class GalaxyRepositoryImpl {
  Future<Either<SSHAuthFailError, SSHClient>> connect(Server server, int port);
  Future<SSHClient> close(SSHClient client);
}

class GalaxyRepository implements GalaxyRepositoryImpl {
  @override
  Future<Either<SSHAuthFailError, SSHClient>> connect(Server server, int port) async {
    late SSHClient client;

    try {
      client = SSHClient(
        await SSHSocket.connect(server.ipAddress!, port),
        username: server.hostname!,
        onPasswordRequest: () => server.password
      );

      await client.authenticated;
      return Right(client);
    } on SSHAuthFailError catch (e) {
      client.close();
      return Left(SSHAuthFailError(e.message + ": please check if the host and password is correct"));
    } on SocketException catch (e) {
      // socket exception throwed (only on android) when server could not be reachable
      return Left(SSHAuthFailError(e.message + ": Please check if the server is reachable"));
    }
  }

  @override
  Future<SSHClient> close(SSHClient client) async {
    if (!client.isClosed) client.close();
    return client;
  }
}