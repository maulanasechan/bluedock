import 'package:bluedock/features/product/domain/entities/selection_entity.dart';

abstract class SelectionDisplayState {}

class SelectionDisplayLoading extends SelectionDisplayState {}

class SelectionDisplayFetched extends SelectionDisplayState {
  final List<SelectionEntity> listSelection;

  SelectionDisplayFetched({required this.listSelection});
}

class SelectionDisplayFailure extends SelectionDisplayState {
  final String message;

  SelectionDisplayFailure({required this.message});
}
