import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:dartz/dartz.dart';

abstract class GalaxyRepositoryImpl {
  Future<Either<SSHAuthFailError, SSHClient>> connect(Server server, int port);
}

class GalaxyRepository implements GalaxyRepositoryImpl {
  @override
  Future<Either<SSHAuthFailError, SSHClient>> connect(Server server, int port) async {
    final client = SSHClient(
      await SSHSocket.connect(server.ipAddress!, port),
      username: server.hostname!,
      onPasswordRequest: () => server.password
    );
    
    try {
      await client.authenticated;
      return Right(client);
    } on SSHAuthFailError catch (e) {
      client.close();
      return Left(e);
    }
  }
}