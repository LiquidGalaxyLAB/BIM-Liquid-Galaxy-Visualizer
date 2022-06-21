import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';

abstract class GalaxyRepositoryImpl {
  Future<Either<SSHAuthFailError, SSHClient>> connect(Server server, int port);
  Future<SSHClient> close(SSHClient client);
  Future<int> execute(SSHClient client, String command);
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

  @override
  Future<int> execute(SSHClient client, String command) async {
    final session = await client.execute(command);
    await session.stdin.close();
    await session.done;
    
    int? code = session.exitCode;
    if (code != null) {
      if (code == 0) return code;
      return -1;
    }

    // command executed but script doesnt return an exit code so we assume it was successful
    return 0;
  }
}