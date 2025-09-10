import 'package:flutter_starter/core/network/dio_service.dart';
import 'package:dio/dio.dart';
import '../domain/access_report_repository.dart';
import 'report_model.dart';
import 'package:intl/intl.dart';

class AccessReportRepositoryImpl implements AccessReportRepository {
  final DioService _dioService;
  AccessReportRepositoryImpl(this._dioService);

  @override
  Future<List<AccessReport>> fetchReports({
    required String residentId,
    required DateTime start,
    required DateTime end,
  }) async {
    try {
      final Response response = await _dioService.dioInstance.get(
        // TODO: confirm exact endpoint from backend docs
        'reports/',
        queryParameters: () {
          final fmt = DateFormat('yyyy-MM-dd');
          return {
            // Common variants the backend may accept
            'resident_id': residentId,
            'resident': residentId,
            'start': start.toIso8601String(),
            'end': end.toIso8601String(),
            'start_date': fmt.format(start),
            'end_date': fmt.format(end),
          };
        }(),
      );

      final raw = response.data;
      List<dynamic> list;
      if (raw is List) {
        list = raw;
      } else if (raw is Map<String, dynamic>) {
        if (raw['results'] is List) {
          list = raw['results'] as List;
        } else if (raw['data'] is List) {
          list = raw['data'] as List;
        } else if (raw['reports'] is List) {
          list = raw['reports'] as List;
        } else if (raw['report'] is List) {
          list = raw['report'] as List;
        } else if (raw.isNotEmpty) {
          // single object fallback
          list = [raw];
        } else {
          list = const [];
        }
      } else {
        list = const [];
      }

      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => AccessReport.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
