import 'package:freezed_annotation/freezed_annotation.dart';

part 'resident_model.freezed.dart';
part 'resident_model.g.dart';

@freezed
sealed class ResidentModel with _$ResidentModel {
  const factory ResidentModel({
    String? id,
    required String name,
    @JsonKey(name: 'date_of_birth') required String dateOfBirth,
    String? url,
    @JsonKey(name: 'care_home') CareHome? careHome,
    @JsonKey(name: 'created_by') String? createdBy,
  }) = _ResidentModel;

  factory ResidentModel.fromJson(Map<String, dynamic> json) =>
      _$ResidentModelFromJson(json);
}

@freezed
sealed class CareHome with _$CareHome {
  const factory CareHome({required String name}) = _CareHome;

  factory CareHome.fromJson(Map<String, dynamic> json) =>
      _$CareHomeFromJson(json);
}
