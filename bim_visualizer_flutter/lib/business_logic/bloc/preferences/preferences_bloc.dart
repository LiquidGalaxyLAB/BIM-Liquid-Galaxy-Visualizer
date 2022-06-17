import 'package:bim_visualizer_flutter/data/repositories/preferences_repository.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

part 'preferences_event.dart';
part 'preferences_state.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  final PreferencesRepository _preferencesRepo;
  
  PreferencesBloc(this._preferencesRepo) : super(PreferencesInitial()) {
    on<PreferencesUpdate>(_mapPreferencesUpdateToState);
    on<PreferencesClear>(_mapPreferencesClearToState);
    on<PreferencesGet>(_mapPreferencesGetToState);
  }

  Future<void> _mapPreferencesUpdateToState(PreferencesUpdate event, Emitter<PreferencesState> emit) async {
    await _preferencesRepo.set(event.server);
    emit(PreferencesUpdateSuccess());
  }

  Future<void> _mapPreferencesClearToState(PreferencesClear event, Emitter<PreferencesState> emit) async {
    await _preferencesRepo.clear();
    emit(PreferencesClearSuccess());
  }

  Future<void> _mapPreferencesGetToState(PreferencesGet event, Emitter<PreferencesState> emit) async {
    final server = _preferencesRepo.get();
    emit(PreferencesGetSuccess(server));
  }
}
