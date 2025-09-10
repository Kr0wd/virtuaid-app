import '../data/report_model.dart';

abstract class AccessReportRepository {
  Future<List<AccessReport>> fetchReports({
    required String residentId,
    required DateTime start,
    required DateTime end,
  });
}
