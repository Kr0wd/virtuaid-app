import '../models/resident_model.dart';
import '../models/resident_response.dart';

abstract class ResidentRepository {
  /// Adds a new resident
  Future<void> addResident(ResidentModel resident);

  /// Fetches residents data from the API
  Future<ResidentResponse> getResidents();
}
