part of 'galaxy_bloc.dart';

abstract class GalaxyState {
  const GalaxyState();
  
  List<Object> get props => [];
}

class GalaxyInitial extends GalaxyState {}

class GalaxyConnectSuccess extends GalaxyState {
  final SSHClient client;

  const GalaxyConnectSuccess(this.client);

  @override
  List<Object> get props => [client];
}

class GalaxyConnectFailure extends GalaxyState {
  final String error;

  const GalaxyConnectFailure(this.error);

  @override
  List<Object> get props => [error];
}

class GalaxyCloseSuccess extends GalaxyState {}

class GalaxyCloseFailure extends GalaxyState {
  final String error;

  const GalaxyCloseFailure(this.error);

  @override
  List<Object> get props => [error];
}

class GalaxyExecuteSuccess extends GalaxyState {}

class GalaxyExecuteFailure extends GalaxyState {
  final String error;

  const GalaxyExecuteFailure(this.error);

  @override
  List<Object> get props => [error];
}