import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/report_model.dart';
import '../domain/access_report_repository.dart';

class AccessReportCubit extends Cubit<AccessReportState> {
  final AccessReportRepository repository;
  AccessReportCubit(this.repository) : super(AccessReportInitial());

  Future<List<AccessReport>> fetchReports({
    required String residentId,
    required DateTime start,
    required DateTime end,
  }) async {
    emit(AccessReportLoading());
    try {
      final reports = await repository.fetchReports(
        residentId: residentId,
        start: start,
        end: end,
      );
      emit(AccessReportLoaded(reports));
      return reports;
    } catch (e) {
      emit(AccessReportError(e.toString()));
      rethrow;
    }
  }
}

abstract class AccessReportState {}

class AccessReportInitial extends AccessReportState {}

class AccessReportLoading extends AccessReportState {}

class AccessReportLoaded extends AccessReportState {
  final List<AccessReport> reports;
  AccessReportLoaded(this.reports);
}

class AccessReportError extends AccessReportState {
  final String message;
  AccessReportError(this.message);
}
