part of 'bim_bloc.dart';

abstract class BimState extends Equatable {
  const BimState();
  
  @override
  List<Object> get props => [];
}

class BimInitial extends BimState {}

class BimGetSuccess extends BimState {
  final List<Bim> bim;

  const BimGetSuccess(this.bim);

  @override
  List<Object> get props => [bim];
}

class BimGetFailure extends BimState {
  final String error;

  const BimGetFailure(this.error);

  @override
  List<Object> get props => [error];
}

class BimUploadSuccess extends BimState {
  final String id;

  const BimUploadSuccess(this.id);

  @override
  List<Object> get props => [id];
}

class BimUploadFailure extends BimState {
  final String error;

  const BimUploadFailure(this.error);
  
  @override
  List<Object> get props => [error];
}

class BimUploadInProgress extends BimState { }

class BimUpdateMetaSuccess extends BimState {
  final Bim bim;

  const BimUpdateMetaSuccess(this.bim);

  @override
  List<Object> get props => [bim];
}

class BimUpdateMetaInProgress extends BimState {}

class BimUpdateMetaFailure extends BimState {
  final String error;

  const BimUpdateMetaFailure(this.error);
  
  @override
  List<Object> get props => [error];
}