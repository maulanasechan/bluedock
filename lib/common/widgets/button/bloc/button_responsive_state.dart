abstract class ButtonResponsiveState {}

class ButtonResponsiveInitial extends ButtonResponsiveState {}

class ButtonResponsiveLoading extends ButtonResponsiveState {}

class ButtonResponsiveSuccess extends ButtonResponsiveState {}

class ButtonResponsiveFailure extends ButtonResponsiveState {
  final String errorMessage;
  ButtonResponsiveFailure({required this.errorMessage});
}
