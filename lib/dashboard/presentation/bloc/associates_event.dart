abstract class AssociatesEvent {
  const AssociatesEvent();
}

class FetchAssociates extends AssociatesEvent {
  const FetchAssociates();
}

class RefreshAssociates extends AssociatesEvent {
  const RefreshAssociates();
}
