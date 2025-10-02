import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';

Future<bool> waitActionDone(ActionButtonCubit cubit) async {
  final s = await cubit.stream.firstWhere(
    (s) => s is ActionButtonSuccess || s is ActionButtonFailure,
  );
  return s is ActionButtonSuccess;
}
