part of 'preferences_bloc.dart';

abstract class PreferencesEvent extends Equatable {
  const PreferencesEvent();

  @override
  List<Object> get props => [];
}

class PreferencesGet extends PreferencesEvent {}

class PreferencesUpdate extends PreferencesEvent {
  final Server server;

  const PreferencesUpdate(this.server);

  @override
  List<Object> get props => [ server ];
}

class PreferencesClear extends PreferencesEvent {}