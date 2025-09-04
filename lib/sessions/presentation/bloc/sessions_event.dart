part of 'sessions_bloc.dart';

abstract class SessionsEvent {
  const SessionsEvent();
}

class FetchSessions extends SessionsEvent {
  final int? page;
  final int? pageSize;
  final String? searchQuery;
  final String? status;

  const FetchSessions({
    this.page,
    this.pageSize,
    this.searchQuery,
    this.status,
  });
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

class FetchSessionEmotionAnalyses extends SessionsEvent {
  final int sessionId;

  const FetchSessionEmotionAnalyses({required this.sessionId});
}
