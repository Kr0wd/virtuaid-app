import 'package:freezed_annotation/freezed_annotation.dart';

part 'resident_model.freezed.dart';
part 'resident_model.g.dart';

@freezed
sealed class ResidentModel with _$ResidentModel {
  const factory ResidentModel({
    required String name,
    @JsonKey(name: 'date_of_birth') required String dateOfBirth,
  }) = _ResidentModel;

  factory ResidentModel.fromJson(Map<String, dynamic> json) =>
      _$ResidentModelFromJson(json);
}
