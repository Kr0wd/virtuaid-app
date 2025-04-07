import '../models/session_response.dart';
import '../models/session_model.dart';

abstract class SessionRepository {
  /// Fetches sessions data from the API
  Future<SessionResponse> getSessions();

  /// Updates a session with the given id
  Future<SessionModel> updateSession(int id, Map<String, dynamic> data);
}
