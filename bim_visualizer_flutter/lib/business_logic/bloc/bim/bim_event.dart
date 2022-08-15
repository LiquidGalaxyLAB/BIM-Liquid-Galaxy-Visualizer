part of 'bim_bloc.dart';

abstract class BimEvent {
  const BimEvent();

  List<Object> get props => [];
}

class BimGet extends BimEvent { }

class BimUpload extends BimEvent {
  final String name;
  final File file;

  const BimUpload(this.name, this.file);

  @override
  List<Object> get props => [name, file];
}

class BimUpdateMeta extends BimEvent {
  final Bim bim;
  final File file;

  const BimUpdateMeta(this.bim, this.file);

  @override
  List<Object> get props => [bim, file];
}