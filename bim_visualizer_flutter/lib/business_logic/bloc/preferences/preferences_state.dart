part of 'preferences_bloc.dart';

abstract class PreferencesState extends Equatable {
  const PreferencesState();
  
  @override
  List<Object> get props => [];
}

class PreferencesInitial extends PreferencesState {}

class PreferencesGetSuccess extends PreferencesState {
  final Server server;

  const PreferencesGetSuccess(this.server);

  @override
  List<Object> get props => [server];
}
class PreferencesUpdateSuccess extends PreferencesState {}
class PreferencesClearSuccess extends PreferencesState {}
