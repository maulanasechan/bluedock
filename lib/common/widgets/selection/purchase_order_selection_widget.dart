import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/dropdown/dropdown_widget.dart';
import 'package:bluedock/common/widgets/modal/bottom_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_display_cubit.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_display_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PurchaseOrderSelectionWidget extends StatelessWidget {
  final String title;
  final String selected;
  final void Function(PurchaseOrderEntity) onPressed;
  final PhosphorIconData? icon;
  final double heightButton;
  final List<BlocProvider> extraProviders;
  final bool? withoutTitle;
  final String? status;

  const PurchaseOrderSelectionWidget({
    super.key,
    required this.title,
    required this.selected,
    required this.onPressed,
    this.icon,
    this.heightButton = 100,
    required this.extraProviders,
    this.withoutTitle = false,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownWidget(
      icon: icon,
      title: withoutTitle! ? null : title,
      state: selected == '' ? title : selected,
      validator: (_) => selected == '' ? '$title is required.' : null,
      onTap: () {
        BottomModalWidget.display(
          context,
          height: MediaQuery.of(context).size.height,
          MultiBlocProvider(
            providers: [
              ...extraProviders,
              BlocProvider.value(
                value: context.read<PurchaseOrderDisplayCubit>()
                  ..displayInitial(),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Choose one $title:',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  const SizedBox(height: 24),
                  TextfieldWidget(
                    prefixIcon: PhosphorIconsBold.magnifyingGlass,
                    borderRadius: 60,
                    iconColor: AppColors.darkBlue,
                    hintText: 'Search',
                    onChanged: (value) {
                      context.read<PurchaseOrderDisplayCubit>().setKeyword(
                        value,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child:
                        BlocBuilder<
                          PurchaseOrderDisplayCubit,
                          PurchaseOrderDisplayState
                        >(
                          builder: (context, state) {
                            if (state is PurchaseOrderDisplayLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is PurchaseOrderDisplayFailure) {
                              return Center(child: Text(state.message));
                            }
                            if (state is PurchaseOrderDisplayFetched) {
                              final activeProjects = status == null
                                  ? state.listPurchaseOrder
                                  : state.listPurchaseOrder
                                        .where((p) => p.status != status)
                                        .toList();

                              if (activeProjects.isEmpty) {
                                return const Center(
                                  child: Text('Purchase Order not found'),
                                );
                              }
                              return ListView.separated(
                                padding: const EdgeInsets.only(bottom: 3),
                                itemCount: activeProjects.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 20),
                                itemBuilder: (context, index) {
                                  final value = activeProjects[index];
                                  final isSelected = selected == value.poName;
                                  return ButtonWidget(
                                    height: heightButton,
                                    background: isSelected
                                        ? AppColors.blue
                                        : AppColors.white,
                                    onPressed: () => onPressed(value),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 42,
                                        vertical: 12,
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                              text: value.poName,
                                              color: isSelected
                                                  ? AppColors.white
                                                  : AppColors.darkBlue,
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            SizedBox(height: 8),
                                            TextWidget(
                                              text:
                                                  "${value.sellerCompany} - ${value.sellerContact}",
                                              color: isSelected
                                                  ? AppColors.white
                                                  : AppColors.darkBlue,
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            SizedBox(height: 8),
                                            TextWidget(
                                              text:
                                                  '${value.productCategory!.title} - ${value.productSelection!.productModel}',
                                              color: isSelected
                                                  ? AppColors.white
                                                  : AppColors.darkBlue,
                                              overflow: TextOverflow.fade,
                                              fontSize: 14,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
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
