import 'package:freezed_annotation/freezed_annotation.dart';

part 'resident_event.freezed.dart';

@freezed
sealed class ResidentEvent with _$ResidentEvent {
  const factory ResidentEvent.fetchResidents() = FetchResidents;
  const factory ResidentEvent.refreshResidents() = RefreshResidents;
}
