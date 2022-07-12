part of 'galaxy_bloc.dart';

abstract class GalaxyEvent {
  const GalaxyEvent();

  List<Object> get props => [];
}

class GalaxyConnect extends GalaxyEvent {
  final Server server;
  final int port;

  const GalaxyConnect(this.server, this.port);
}

class GalaxyClose extends GalaxyEvent {
  final SSHClient client;

  const GalaxyClose(this.client);
}

class GalaxyExecute extends GalaxyEvent {
  final SSHClient client;
  final String command;

  const GalaxyExecute(this.client, this.command);
}

class GalaxyCreateLink extends GalaxyEvent {
  final SSHClient client;
  final String key;
  final String target;

  const GalaxyCreateLink(this.client, this.key, this.target);
}