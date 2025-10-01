import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/features/product/domain/entities/selection_entity.dart';
import 'package:bluedock/features/product/presentation/bloc/selection/selection_display_cubit.dart';
import 'package:bluedock/features/product/presentation/bloc/selection/selection_display_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectionModalWidget extends StatelessWidget {
  final Widget Function(BuildContext, List<SelectionEntity>) builder;
  final String title;
  const SelectionModalWidget({
    super.key,
    required this.title,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionDisplayCubit, SelectionDisplayState>(
      builder: (context, state) {
        if (state is SelectionDisplayLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is SelectionDisplayFailure) {
          return Center(child: Text(state.message));
        }
        if (state is SelectionDisplayFetched) {
          return _displaySelection(context, state.listSelection);
        }
        return SizedBox();
      },
    );
  }

  Widget _displaySelection(
    BuildContext context,
    List<SelectionEntity> listSelection,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(text: title, fontWeight: FontWeight.w700, fontSize: 18),
          SizedBox(height: 16),
          Expanded(child: builder(context, listSelection)),
        ],
      ),
    );
  }
}
