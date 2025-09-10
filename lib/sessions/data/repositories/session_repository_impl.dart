import 'package:dio/dio.dart';
import '../../../core/network/dio_service.dart';
import '../models/session_model.dart';
import '../models/emotion_analysis_model.dart';
import '../models/sessions_response.dart';
import 'session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final DioService _dioService;

  SessionRepositoryImpl(this._dioService);

  @override
  Future<SessionsResponse> getSessions({
    int? page,
    int? pageSize,
    String? searchQuery,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (pageSize != null) queryParams['page_size'] = pageSize;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await _dioService.dioInstance.get(
        'sessions/',
        queryParameters: queryParams,
      );
      return SessionsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to load sessions: ${e.toString()}');
    }
  }

  @override
  Future<SessionModel> getSessionById(int id) async {
    try {
      final response = await _dioService.dioInstance.get('sessions/$id/');
      return SessionModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to load session: ${e.toString()}');
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

  @override
  Future<List<EmotionAnalysisModel>> getSessionEmotionAnalyses(
    int sessionId,
  ) async {
    try {
      // Correct endpoint per integrate.md: /sessions/{session_id}/videos/
      final response = await _dioService.dioInstance.get(
        'sessions/$sessionId/videos/',
      );

      final raw = response.data;
      final List list;
      if (raw is List) {
        list = raw;
      } else if (raw is Map && raw['results'] is List) {
        list = raw['results'];
      } else if (raw is Map && raw['data'] is List) {
        list = raw['data'];
      } else if (raw is Map && raw.isNotEmpty) {
        list = [raw];
      } else {
        list = const [];
      }

      return list
          .whereType<Map<String, dynamic>>()
          .map((item) => EmotionAnalysisModel.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to fetch emotion analyses: ${e.toString()}');
    }
  }

  @override
  Future<SessionModel> updateSessionNotes({
    required int sessionId,
    required String notes,
  }) async {
    try {
      final response = await _dioService.dioInstance.patch(
        'sessions/$sessionId/',
        data: {'notes': notes},
      );
      return SessionModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to update session notes: ${e.toString()}');
    }
  }

  @override
  Future<SessionModel> updateSessionStatus({
    required int sessionId,
    required String status,
  }) async {
    try {
      final response = await _dioService.dioInstance.patch(
        'sessions/$sessionId/',
        data: {'status': status},
      );
      return SessionModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to update session status: ${e.toString()}');
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
