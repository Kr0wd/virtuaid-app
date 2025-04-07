part of 'sessions_bloc.dart';

abstract class SessionsState {
  const SessionsState();

  // Add a default implementation that returns -1 when no session is being updated
  int get updatingSessionId => -1;
}

class SessionsInitial extends SessionsState {}

class SessionsLoading extends SessionsState {}

class SessionsLoaded extends SessionsState {
  final SessionResponse sessionResponse;

  const SessionsLoaded(this.sessionResponse);
}

class SessionsError extends SessionsState {
  final String message;

  const SessionsError(this.message);
}

class SessionUpdateLoading extends SessionsState {
  @override
  final int updatingSessionId;

  const SessionUpdateLoading(this.updatingSessionId);
}

class SessionUpdateSuccess extends SessionsState {
  final SessionModel updatedSession;

  const SessionUpdateSuccess(this.updatedSession);
}

class SessionUpdateError extends SessionsState {
  final String message;

  const SessionUpdateError(this.message);
}
