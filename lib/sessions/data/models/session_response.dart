import 'package:freezed_annotation/freezed_annotation.dart';
import 'session_model.dart';

part 'session_response.freezed.dart';
part 'session_response.g.dart';

@freezed
sealed class SessionResponse with _$SessionResponse {
  const factory SessionResponse({
    required int count,
    String? next,
    String? previous,
    required List<SessionModel> results,
  }) = _SessionResponse;

  factory SessionResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionResponseFromJson(json);
}
