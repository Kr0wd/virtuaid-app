import 'package:flutter_starter/dashboard/data/models/associates_response.dart';

abstract class AssociatesRepository {
  /// Fetches associates data from the API
  Future<AssociatesResponse> getAssociates();
}
