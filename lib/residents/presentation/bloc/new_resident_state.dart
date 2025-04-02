import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_resident_state.freezed.dart';

@freezed
sealed class NewResidentState with _$NewResidentState {
  const factory NewResidentState.initial() = NewResidentInitial;
  const factory NewResidentState.loading() = NewResidentLoading;
  const factory NewResidentState.success() = NewResidentSuccess;
  const factory NewResidentState.error(String message) = NewResidentError;
}
