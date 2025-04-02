import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_resident_event.freezed.dart';

@freezed
sealed class NewResidentEvent with _$NewResidentEvent {
  const factory NewResidentEvent.addResident({
    required String name,
    required String dateOfBirth,
  }) = AddResident;
}
