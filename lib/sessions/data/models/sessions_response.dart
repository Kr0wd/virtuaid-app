import 'package:json_annotation/json_annotation.dart';
import 'session_model.dart';

part 'sessions_response.g.dart';

@JsonSerializable()
class SessionsResponse {
  final List<SessionModel> results;
  final int count;
  @JsonKey(name: 'next')
  final String? nextPageUrl;
  @JsonKey(name: 'previous')
  final String? previousPageUrl;

  SessionsResponse({
    required this.results,
    required this.count,
    this.nextPageUrl,
    this.previousPageUrl,
  });

  factory SessionsResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SessionsResponseToJson(this);
}
