import 'package:freezed_annotation/freezed_annotation.dart';
import 'resident_model.dart';

part 'resident_response.freezed.dart';
part 'resident_response.g.dart';

@freezed
sealed class ResidentResponse with _$ResidentResponse {
  const factory ResidentResponse({
    required int count,
    String? next,
    String? previous,
    required List<ResidentModel> results,
  }) = _ResidentResponse;

  factory ResidentResponse.fromJson(Map<String, dynamic> json) =>
      _$ResidentResponseFromJson(json);
}
