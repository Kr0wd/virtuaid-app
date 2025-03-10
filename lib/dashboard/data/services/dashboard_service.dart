import 'package:dio/dio.dart';
import 'package:flutter_starter/core/network/dio_service.dart';
import 'package:flutter_starter/dashboard/data/models/associates_response.dart';

class DashboardService {
  final DioService _dioService;

  DashboardService(this._dioService);

  Future<AssociatesResponse> getAssociates() async {
    try {
      final response = await _dioService.dioInstance.get('associates/');
      return AssociatesResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load associates: ${e.message}');
    }
  }
}
