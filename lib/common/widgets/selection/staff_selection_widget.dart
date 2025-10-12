import 'package:bluedock/common/bloc/staff/staff_display_cubit.dart';
import 'package:bluedock/common/bloc/staff/staff_display_state.dart';
import 'package:bluedock/common/domain/entities/staff_entity.dart';
import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/modal/bottom_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StaffSelectionWidget extends StatelessWidget {
  final String title;
  final List<StaffEntity> selected;
  final void Function(StaffEntity) onPressed;
  final PhosphorIconData? icon;
  final double heightButton;
  final List<BlocProvider> extraProviders;

  const StaffSelectionWidget({
    super.key,
    required this.title,
    required this.selected,
    required this.onPressed,
    this.icon,
    this.heightButton = 90,
    this.extraProviders = const <BlocProvider>[],
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (_) => selected.isEmpty ? '$title is required.' : null,
      builder: (field) {
        final hasError = field.hasError;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(text: title, fontSize: 16, fontWeight: FontWeight.w500),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                BottomModalWidget.display(
                  context,
                  height: MediaQuery.of(context).size.height,
                  MultiBlocProvider(
                    providers: [
                      ...extraProviders,
                      BlocProvider.value(
                        value: context.read<StaffDisplayCubit>()
                          ..displayStaff(params: ''),
                      ),
                    ],
                    child: Builder(
                      builder: (modalContext) {
                        final localSelectedIds = selected
                            .map((e) => e.staffId)
                            .toSet();

                        void toggleLocal(StaffEntity v, VoidCallback rebuild) {
                          if (localSelectedIds.contains(v.staffId)) {
                            localSelectedIds.remove(v.staffId);
                          } else {
                            localSelectedIds.add(v.staffId);
                          }
                          rebuild();
                          onPressed(v);
                          field.didChange('changed');
                        }

                        return StatefulBuilder(
                          builder: (context, setModalState) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: 'Choose $title:',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                  const SizedBox(height: 24),

                                  TextfieldWidget(
                                    prefixIcon:
                                        PhosphorIconsBold.magnifyingGlass,
                                    borderRadius: 60,
                                    iconColor: AppColors.darkBlue,
                                    hintText: 'Search',
                                    onChanged: (value) => modalContext
                                        .read<StaffDisplayCubit>()
                                        .displayStaff(params: value),
                                  ),
                                  const SizedBox(height: 24),

                                  // List Staff
                                  Expanded(
                                    child: BlocBuilder<StaffDisplayCubit, StaffDisplayState>(
                                      builder: (context, state) {
                                        if (state is StaffDisplayLoading) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        if (state is StaffDisplayFailure) {
                                          return Center(
                                            child: Text(state.message),
                                          );
                                        }
                                        if (state is! StaffDisplayFetched) {
                                          return const SizedBox.shrink();
                                        }

                                        final list = state.listStaff;
                                        if (list.isEmpty) {
                                          return const Center(
                                            child: Text('No staff found'),
                                          );
                                        }

                                        return ListView.separated(
                                          padding: const EdgeInsets.only(
                                            bottom: 3,
                                          ),
                                          itemCount: list.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 16),
                                          itemBuilder: (context, index) {
                                            final value = list[index];
                                            final chosen = localSelectedIds
                                                .contains(value.staffId);

                                            return ButtonWidget(
                                              height: heightButton,
                                              background: chosen
                                                  ? AppColors.blue
                                                  : AppColors.white,
                                              title: value.fullName,
                                              content: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                    ),
                                                child: Row(
                                                  children: [
                                                    _StaffAvatar(
                                                      imageUrl: value.image,
                                                      name: value.fullName,
                                                    ),
                                                    const SizedBox(width: 24),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextWidget(
                                                            text:
                                                                value.fullName,
                                                            color: chosen
                                                                ? AppColors
                                                                      .white
                                                                : AppColors
                                                                      .darkBlue,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          TextWidget(
                                                            text: value
                                                                .role
                                                                .title,
                                                            color: chosen
                                                                ? AppColors
                                                                      .white
                                                                : AppColors
                                                                      .blue,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                          ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          TextWidget(
                                                            text: value
                                                                .phoneNumber,
                                                            color: chosen
                                                                ? AppColors
                                                                      .white
                                                                : AppColors
                                                                      .darkBlue,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onPressed: () =>
                                                  toggleLocal(value, () {
                                                    setModalState(() {});
                                                  }),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },

              // === PREVIEW CHIPS ===
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(
                      width: 1.5,
                      color: hasError ? AppColors.blue : AppColors.border,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: selected.isEmpty
                            ? TextWidget(
                                text: title,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkBlue,
                              )
                            : Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: selected.map((s) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextWidget(
                                      text: s.fullName,
                                      color: AppColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                      PhosphorIcon(
                        icon ?? PhosphorIconsBold.caretDown,
                        color: AppColors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (hasError) const SizedBox(height: 8),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  field.errorText ?? '$title is required.',
                  style: TextStyle(color: AppColors.blue, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _StaffAvatar extends StatelessWidget {
  final String imageUrl;
  final String name;
  const _StaffAvatar({required this.imageUrl, required this.name});
  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      final initials = name.isNotEmpty
          ? name
                .trim()
                .split(RegExp(r'\s+'))
                .take(2)
                .map((e) => e[0])
                .join()
                .toUpperCase()
          : '?';
      return CircleAvatar(
        radius: 35,
        backgroundColor: AppColors.blueSecondary,
        child: Text(
          initials,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );
    }
    return CircleAvatar(
      radius: 35,
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (_, __) {},
    );
  }
}
