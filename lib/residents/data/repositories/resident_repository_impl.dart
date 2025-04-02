import 'package:dio/dio.dart';
import '../../../core/network/dio_service.dart';
import '../models/resident_model.dart';
import '../models/resident_response.dart';
import 'resident_repository.dart';

class ResidentRepositoryImpl implements ResidentRepository {
  final DioService _dioService;

  ResidentRepositoryImpl(this._dioService);

  @override
  Future<void> addResident(ResidentModel resident) async {
    try {
      await _dioService.dioInstance.post('residents/', data: resident.toJson());
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to add resident: ${e.toString()}');
    }
  }

  @override
  Future<ResidentResponse> getResidents() async {
    try {
      final response = await _dioService.dioInstance.get('residents/');
      return ResidentResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to load residents: ${e.toString()}');
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
