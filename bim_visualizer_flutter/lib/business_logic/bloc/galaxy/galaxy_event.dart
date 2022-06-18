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
