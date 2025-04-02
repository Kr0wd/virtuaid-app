import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../residents/data/repositories/resident_repository.dart';
import 'resident_event.dart';
import 'resident_state.dart';

class ResidentBloc extends Bloc<ResidentEvent, ResidentState> {
  final ResidentRepository _residentRepository;

  ResidentBloc(this._residentRepository)
    : super(const ResidentState.initial()) {
    on<ResidentEvent>((event, emit) async {
      switch (event) {
        case FetchResidents():
          await _onFetchResidents(emit);
        case RefreshResidents():
          await _onRefreshResidents(emit);
      }
    });
  }

  Future<void> _onFetchResidents(Emitter<ResidentState> emit) async {
    emit(const ResidentState.loading());
    try {
      final residents = await _residentRepository.getResidents();
      emit(ResidentState.loaded(residents));
    } catch (e) {
      emit(ResidentState.error(e.toString()));
    }
  }

  Future<void> _onRefreshResidents(Emitter<ResidentState> emit) async {
    try {
      final residents = await _residentRepository.getResidents();
      emit(ResidentState.loaded(residents));
    } catch (e) {
      emit(ResidentState.error(e.toString()));
    }
  }
}
