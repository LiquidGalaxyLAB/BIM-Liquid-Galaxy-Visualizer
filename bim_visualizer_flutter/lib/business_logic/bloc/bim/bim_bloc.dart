import 'package:bim_visualizer_flutter/data/repositories/node_api_repository.dart';
import 'package:bim_visualizer_flutter/data/models/bim_model.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'dart:io';

part 'bim_event.dart';
part 'bim_state.dart';

class BimBloc extends Bloc<BimEvent, BimState> {
  final NodeAPIRepository _nodeAPIRepo;

  BimBloc(this._nodeAPIRepo) : super(BimInitial()) {
    on<BimGet>(_mapBimGetToState);
    on<BimUpload>(_mapBimUploadToState);
    on<BimUpdateMeta>(_mapBimUpdateMetaToState);
  }

  Future<void> _mapBimGetToState(BimGet event, Emitter<BimState> emit) async {
    final http.Client client = http.Client();
    final result = await _nodeAPIRepo.getAll(client);

    result.fold(
      (l) => emit(BimGetFailure(l.toString())),
      (r) => emit(BimGetSuccess(r)),
    );
  }

  Future<void> _mapBimUploadToState(BimUpload event, Emitter<BimState> emit) async {
    emit(BimUploadInProgress());
    
    final http.Client client = http.Client();
    final result = await _nodeAPIRepo.uploadModel(client, event.name, event.file);

    result.fold(
      (l) => emit(BimUploadFailure(l.toString())),
      (r) => emit(BimUploadSuccess(r)),
    );
  }

  Future<void> _mapBimUpdateMetaToState(BimUpdateMeta event, Emitter<BimState> emit) async {
    emit(BimUpdateMetaInProgress());

    final http.Client client = http.Client();
    final result = await _nodeAPIRepo.updateMeta(client, event.bim, event.file);

    result.fold(
      (l) => emit(BimUpdateMetaFailure(l.toString())),
      (r) => emit(BimUpdateMetaSuccess(r))
    );
  }
}
