import 'package:dio/dio.dart';
import 'package:flutter_starter/core/network/dio_service.dart';
import 'package:flutter_starter/dashboard/data/models/associates_response.dart';
import 'package:flutter_starter/dashboard/domain/repositories/associates_repository.dart';

class AssociatesRepositoryImpl implements AssociatesRepository {
  final DioService _dioService;

  AssociatesRepositoryImpl(this._dioService);

  @override
  Future<AssociatesResponse> getAssociates() async {
    try {
      final response = await _dioService.dioInstance.get('associates/');
      return AssociatesResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load associates: ${e.message}');
    }
  }
}
