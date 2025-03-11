import 'package:flutter_starter/dashboard/data/models/associates_response.dart';

abstract class AssociatesState {
  const AssociatesState();
}

class AssociatesInitial extends AssociatesState {
  const AssociatesInitial();
}

class AssociatesLoading extends AssociatesState {
  const AssociatesLoading();
}

class AssociatesLoaded extends AssociatesState {
  final AssociatesResponse data;

  const AssociatesLoaded(this.data);
}

class AssociatesError extends AssociatesState {
  final String message;

  const AssociatesError(this.message);
}
