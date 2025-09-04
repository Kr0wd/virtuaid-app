import '../models/emotion_analysis_model.dart';
import '../models/session_model.dart';
import '../models/sessions_response.dart';

abstract class SessionRepository {
  /// Fetches sessions data from the API
  Future<SessionsResponse> getSessions({
    int? page,
    int? pageSize,
    String? searchQuery,
    String? status,
  });

  /// Fetches a session by its id
  Future<SessionModel> getSessionById(int id);

  /// Updates a session with the given id
  Future<SessionModel> updateSession(int id, Map<String, dynamic> data);

  /// Updates session notes
  Future<SessionModel> updateSessionNotes({
    required int sessionId,
    required String notes,
  });

  /// Updates session status
  Future<SessionModel> updateSessionStatus({
    required int sessionId,
    required String status,
  });

  /// Fetches emotion analyses for a session
  Future<List<EmotionAnalysisModel>> getSessionEmotionAnalyses(int sessionId);
}
