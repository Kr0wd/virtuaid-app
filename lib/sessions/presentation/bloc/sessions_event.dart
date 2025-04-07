part of 'sessions_bloc.dart';

abstract class SessionsEvent {
  const SessionsEvent();
}

class FetchSessions extends SessionsEvent {
  const FetchSessions();
}

class UpdateSessionStatus extends SessionsEvent {
  final int sessionId;
  final String status;

  const UpdateSessionStatus({required this.sessionId, required this.status});
}

class UpdateSessionNotes extends SessionsEvent {
  final int sessionId;
  final String notes;

  const UpdateSessionNotes({required this.sessionId, required this.notes});
}
