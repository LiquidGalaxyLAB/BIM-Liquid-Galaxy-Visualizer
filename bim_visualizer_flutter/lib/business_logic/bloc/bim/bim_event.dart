part of 'bim_bloc.dart';

abstract class BimEvent {
  const BimEvent();

  List<Object> get props => [];
}

class BimGet extends BimEvent { }
