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
