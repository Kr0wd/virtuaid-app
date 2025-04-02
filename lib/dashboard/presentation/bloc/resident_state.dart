import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../residents/data/models/resident_response.dart';

part 'resident_state.freezed.dart';

@freezed
sealed class ResidentState with _$ResidentState {
  const factory ResidentState.initial() = ResidentInitial;
  const factory ResidentState.loading() = ResidentLoading;
  const factory ResidentState.loaded(ResidentResponse data) = ResidentLoaded;
  const factory ResidentState.error(String message) = ResidentError;
}
