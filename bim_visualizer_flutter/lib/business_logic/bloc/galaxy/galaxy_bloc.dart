import 'package:bim_visualizer_flutter/data/repositories/galaxy_repository.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:bloc/bloc.dart';

part 'galaxy_event.dart';
part 'galaxy_state.dart';

class GalaxyBloc extends Bloc<GalaxyEvent, GalaxyState> {
  final GalaxyRepository _galaxyRepo;

  GalaxyBloc(this._galaxyRepo) : super(GalaxyInitial()) {
    on<GalaxyConnect>(_mapGalaxyConnectToState);
    on<GalaxyClose>(_mapGalaxyCloseToState);
    on<GalaxyExecute>(_mapGalaxyExecuteToState);
  }

  Future<void> _mapGalaxyConnectToState(GalaxyConnect event, Emitter<GalaxyState> emit) async {
    final client = await _galaxyRepo.connect(event.server, event.port);
    
    client.fold(
      (l) {
        emit(GalaxyConnectFailure(l.message));
      },
      (r) {
        emit(GalaxyConnectSuccess(r));
      }
    );
  }

  Future<void> _mapGalaxyCloseToState(GalaxyClose event, Emitter<GalaxyState> emit) async {
    final client = await _galaxyRepo.close(event.client);

    if (client.isClosed) {
      emit(GalaxyCloseSuccess());
    } else {
      emit(const GalaxyCloseFailure('Could not close client'));
    }
  }

  Future<void> _mapGalaxyExecuteToState(GalaxyExecute event, Emitter<GalaxyState> emit) async {
    final result = await _galaxyRepo.execute(event.client, event.command);
    if (result != -1) {
      emit(GalaxyExecuteSuccess());
    } else {
      emit(const GalaxyExecuteFailure('Failed to execute the command'));
    }
  }
}
