import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/dashboard/domain/repositories/associates_repository.dart';
import 'package:flutter_starter/dashboard/presentation/bloc/associates_event.dart';
import 'package:flutter_starter/dashboard/presentation/bloc/associates_state.dart';

class AssociatesBloc extends Bloc<AssociatesEvent, AssociatesState> {
  final AssociatesRepository _associatesRepository;

  AssociatesBloc(this._associatesRepository)
    : super(const AssociatesInitial()) {
    on<FetchAssociates>(_onFetchAssociates);
    on<RefreshAssociates>(_onRefreshAssociates);
  }

  Future<void> _onFetchAssociates(
    FetchAssociates event,
    Emitter<AssociatesState> emit,
  ) async {
    emit(const AssociatesLoading());
    try {
      final associates = await _associatesRepository.getAssociates();
      emit(AssociatesLoaded(associates));
    } catch (e) {
      emit(AssociatesError(e.toString()));
    }
  }

  Future<void> _onRefreshAssociates(
    RefreshAssociates event,
    Emitter<AssociatesState> emit,
  ) async {
    try {
      final associates = await _associatesRepository.getAssociates();
      emit(AssociatesLoaded(associates));
    } catch (e) {
      emit(AssociatesError(e.toString()));
    }
  }
}
