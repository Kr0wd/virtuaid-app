import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/resident_model.dart';
import '../../data/repositories/resident_repository.dart';
import 'new_resident_event.dart';
import 'new_resident_state.dart';

class NewResidentBloc extends Bloc<NewResidentEvent, NewResidentState> {
  final ResidentRepository _residentRepository;

  NewResidentBloc(this._residentRepository)
    : super(const NewResidentState.initial()) {
    on<NewResidentEvent>((event, emit) async {
      // Using Dart 3 pattern matching with switch
      switch (event) {
        case AddResident(:final name, :final dateOfBirth):
          await _onAddResident(name, dateOfBirth, emit);
        case NewResidentSubmitted(:final name, :final dateOfBirth):
          await _onSubmitted(name, dateOfBirth, emit);
      }
    });
  }

  Future<void> _onAddResident(
    String name,
    String dateOfBirth,
    Emitter<NewResidentState> emit,
  ) async {
    emit(const NewResidentState.loading());
    try {
      // Creating a resident with nullable id - server will generate the id
      final resident = ResidentModel(
        name: name,
        dateOfBirth: dateOfBirth,
        // Not providing id, url, careHome, or createdBy since those are nullable
        // and will be assigned by the server
      );
      await _residentRepository.addResident(resident);
      emit(const NewResidentState.success());
    } catch (e) {
      emit(NewResidentState.error(e.toString()));
    }
  }

  // Handle the NewResidentSubmitted event
  Future<void> _onSubmitted(
    String name,
    String dateOfBirth,
    Emitter<NewResidentState> emit,
  ) async {
    emit(const NewResidentState.loading());
    try {
      final resident = ResidentModel(
        name: name.trim(),
        dateOfBirth: dateOfBirth,
      );
      await _residentRepository.addResident(resident);
      emit(const NewResidentState.success());
    } catch (e) {
      emit(NewResidentState.error(e.toString()));
    }
  }
}
