import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

@freezed
sealed class CareHome with _$CareHome {
  const factory CareHome({required String name}) = _CareHome;

  factory CareHome.fromJson(Map<String, dynamic> json) =>
      _$CareHomeFromJson(json);
}

@freezed
sealed class ResidentDetails with _$ResidentDetails {
  const factory ResidentDetails({
    required String url,
    required String id,
    required String name,
    @JsonKey(name: 'date_of_birth') required String dateOfBirth,
    @JsonKey(name: 'care_home') required CareHome careHome,
    @JsonKey(name: 'created_by') required String createdBy,
  }) = _ResidentDetails;

  factory ResidentDetails.fromJson(Map<String, dynamic> json) =>
      _$ResidentDetailsFromJson(json);
}

@freezed
sealed class SessionModel with _$SessionModel {
  const factory SessionModel({
    required int id,
    @JsonKey(name: 'resident_details') required ResidentDetails residentDetails,
    @JsonKey(name: 'feedback_status') required String feedbackStatus,
    @JsonKey(name: 'scheduled_date') required String scheduledDate,
    @JsonKey(name: 'end_time') String? endTime,
    required String status,
    String? notes,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    required String resident,
    String? feedback,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
}
