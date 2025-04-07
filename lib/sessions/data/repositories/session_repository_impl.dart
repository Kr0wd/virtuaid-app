import 'package:dio/dio.dart';
import '../../../core/network/dio_service.dart';
import '../models/session_response.dart';
import '../models/session_model.dart';
import 'session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final DioService _dioService;

  SessionRepositoryImpl(this._dioService);

  @override
  Future<SessionResponse> getSessions() async {
    try {
      final response = await _dioService.dioInstance.get('sessions/');
      return SessionResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to load sessions: ${e.toString()}');
    }
  }

  @override
  Future<SessionModel> updateSession(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dioService.dioInstance.patch(
        'sessions/$id/',
        data: data,
      );
      return SessionModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to update session: ${e.toString()}');
    }
  }

  Exception _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response?.data;
      if (data != null && data is Map) {
        String errorMsg = '';
        data.forEach((key, value) {
          if (value is List) {
            errorMsg += '$key: ${value.join(', ')}\n';
          } else {
            errorMsg += '$key: $value\n';
          }
        });
        return Exception(errorMsg.trim());
      }
      return Exception(
        '${error.response?.statusCode}: ${error.response?.statusMessage}',
      );
    }
    return Exception('Network error: ${error.message}');
  }
}
