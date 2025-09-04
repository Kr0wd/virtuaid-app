import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/emotion_analysis_model.dart';
import '../../data/models/session_model.dart';
import '../../data/models/sessions_response.dart';
import '../../data/repositories/session_repository.dart';

part 'sessions_event.dart';
part 'sessions_state.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  final SessionRepository _sessionRepository;

  SessionsBloc(this._sessionRepository) : super(SessionsInitial()) {
    on<FetchSessions>(_onFetchSessions);
    on<UpdateSessionStatus>(_onUpdateSessionStatus);
    on<UpdateSessionNotes>(_onUpdateSessionNotes);
    on<FetchSessionEmotionAnalyses>(_onFetchSessionEmotionAnalyses);
  }

  Future<void> _onFetchSessions(
    FetchSessions event,
    Emitter<SessionsState> emit,
  ) async {
    emit(SessionsLoading());
    try {
      final sessionsResponse = await _sessionRepository.getSessions(
        page: event.page,
        pageSize: event.pageSize,
        searchQuery: event.searchQuery,
        status: event.status,
      );
      emit(SessionsLoaded(sessionsResponse));
    } catch (e) {
      emit(SessionsError(e.toString()));
    }
  }

  Future<void> _onUpdateSessionStatus(
    UpdateSessionStatus event,
    Emitter<SessionsState> emit,
  ) async {
    emit(SessionUpdateLoading(event.sessionId));

    try {
      final updatedSession = await _sessionRepository.updateSessionStatus(
        sessionId: event.sessionId,
        status: event.status,
      );

      emit(SessionUpdateSuccess(updatedSession));

      // Optionally reload the full list after a successful update
      add(const FetchSessions());
    } catch (e) {
      emit(SessionUpdateError(e.toString()));
    }
  }

  Future<void> _onUpdateSessionNotes(
    UpdateSessionNotes event,
    Emitter<SessionsState> emit,
  ) async {
    emit(SessionUpdateLoading(event.sessionId));

    try {
      final updatedSession = await _sessionRepository.updateSessionNotes(
        sessionId: event.sessionId,
        notes: event.notes,
      );

      emit(SessionUpdateSuccess(updatedSession));

      // Optionally reload the full list after a successful update
      add(const FetchSessions());
    } catch (e) {
      emit(SessionUpdateError(e.toString()));
    }
  }

  Future<void> _onFetchSessionEmotionAnalyses(
    FetchSessionEmotionAnalyses event,
    Emitter<SessionsState> emit,
  ) async {
    emit(EmotionAnalysesLoading());
    try {
      final emotionAnalyses = await _sessionRepository
          .getSessionEmotionAnalyses(event.sessionId);
      emit(EmotionAnalysesLoaded(emotionAnalyses));
    } catch (e) {
      emit(EmotionAnalysesError(e.toString()));
    }
  }
}
