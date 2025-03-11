import 'package:freezed_annotation/freezed_annotation.dart';

part 'associates_response.freezed.dart';
part 'associates_response.g.dart';

@freezed
abstract class AssociatesResponse with _$AssociatesResponse {
  const factory AssociatesResponse({
    required int count,
    String? next,
    String? previous,
    required List<dynamic> results,
  }) = _AssociatesResponse;

  factory AssociatesResponse.fromJson(Map<String, dynamic> json) =>
      _$AssociatesResponseFromJson(json);
}

// After adding this file, run:
// flutter pub run build_runner build --delete-conflicting-outputs
// to generate the necessary freezed and json serialization files
