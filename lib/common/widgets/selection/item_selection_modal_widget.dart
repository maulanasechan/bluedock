import 'package:bluedock/common/data/models/itemSelection/item_selection_req.dart';
import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/dropdown/dropdown_widget.dart';
import 'package:bluedock/common/widgets/modal/bottom_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/common/domain/entities/item_selection_entity.dart';
import 'package:bluedock/common/bloc/itemSelection/item_selection_display_cubit.dart';
import 'package:bluedock/common/bloc/itemSelection/item_selection_display_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ItemSelectionModalWidget extends StatelessWidget {
  final String subCollection;
  final String collection;
  final String document;
  final String selected;
  final PhosphorIconData icon;
  final void Function(ItemSelectionEntity) onSelected;
  final List<BlocProvider> extraProviders;
  final bool? withoutIcon;
  final bool? withoutTitle;
  final TextAlign? align;

  const ItemSelectionModalWidget({
    super.key,
    required this.subCollection,
    required this.collection,
    required this.document,
    required this.selected,
    required this.onSelected,
    required this.icon,
    required this.extraProviders,
    this.withoutTitle = false,
    this.withoutIcon = false,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownWidget(
      align: align,
      icon: icon,
      title: withoutTitle! ? null : subCollection,
      state: selected == '' ? subCollection : selected,
      validator: (_) => selected == '' ? '$subCollection is required.' : null,
      withoutIcon: withoutIcon,
      onTap: () {
        BottomModalWidget.display(
          context,
          MultiBlocProvider(
            providers: [
              ...extraProviders,
              BlocProvider.value(
                value: context.read<ItemSelectionDisplayCubit>()
                  ..displaySelection(
                    ItemSelectionReq(
                      collection: collection,
                      document: document,
                      subCollection: subCollection,
                    ),
                  ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: subCollection,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  SizedBox(height: 16),
                  BlocBuilder<
                    ItemSelectionDisplayCubit,
                    ItemSelectionDisplayState
                  >(
                    builder: (context, state) {
                      if (state is ItemSelectionDisplayLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is ItemSelectionDisplayFailure) {
                        return Center(child: Text(state.message));
                      }
                      if (state is ItemSelectionDisplayFetched) {
                        final listSelection = state.listSelection;
                        return Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.only(bottom: 3),
                            itemBuilder: (context, index) {
                              final value = listSelection[index];
                              return ButtonWidget(
                                background: selected == value.title
                                    ? AppColors.blue
                                    : AppColors.white,
                                onPressed: () => onSelected(value),
                                title: value.title,
                                fontColor: selected == value.title
                                    ? AppColors.white
                                    : AppColors.darkBlue,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 20),
                            itemCount: listSelection.length,
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
