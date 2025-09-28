abstract class ActionButtonState {}

class ActionButtonInitial extends ActionButtonState {}

class ActionButtonLoading extends ActionButtonState {}

class ActionButtonSuccess extends ActionButtonState {}

class ActionButtonFailure extends ActionButtonState {
  final String errorMessage;
  ActionButtonFailure({required this.errorMessage});
}
