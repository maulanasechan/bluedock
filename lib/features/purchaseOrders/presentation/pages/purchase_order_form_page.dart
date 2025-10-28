import 'package:bluedock/common/bloc/productSection/product_section_cubit.dart';
import 'package:bluedock/common/bloc/projectSection/project_display_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/common/bloc/itemSelection/item_selection_display_cubit.dart';
import 'package:bluedock/features/inventories/presentation/bloc/inventory_display_cubit.dart';
import 'package:bluedock/features/purchaseOrders/data/models/purchase_order_form_req.dart';
import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';
import 'package:bluedock/features/purchaseOrders/domain/usecases/add_purchase_order_usecase.dart';
import 'package:bluedock/features/purchaseOrders/domain/usecases/update_purchase_order_usecase.dart';
import 'package:bluedock/features/purchaseOrders/presentation/bloc/purchase_order_form_cubit.dart';
import 'package:bluedock/features/purchaseOrders/presentation/widgets/purchase_order_button.dart';
import 'package:bluedock/features/purchaseOrders/presentation/widgets/purchase_order_form_project_widget.dart';
import 'package:bluedock/features/purchaseOrders/presentation/widgets/purchase_order_form_stock_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PurchaseOrderFormPage extends StatelessWidget {
  final PurchaseOrderEntity? purchaseOrder;
  PurchaseOrderFormPage({super.key, this.purchaseOrder});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isUpdate = purchaseOrder != null;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (_) {
            final c = PurchaseOrderFormCubit();
            if (isUpdate) c.hydrateFromEntity(purchaseOrder!);
            return c;
          },
        ),
        BlocProvider(create: (context) => ProductSectionCubit()),
        BlocProvider(create: (context) => ItemSelectionDisplayCubit()),
        BlocProvider(create: (context) => InventoryDisplayCubit()),
        BlocProvider(create: (context) => ProjectDisplayCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: isUpdate
            ? 'Update Purchase Order'
            : 'Create Purchase Order',
        body: BlocListener<ActionButtonCubit, ActionButtonState>(
          listener: (context, state) async {
            if (state is ActionButtonFailure) {
              var snackbar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ActionButtonSuccess) {
              final changed = await context.pushNamed(
                AppRoutes.purchaseOrderSuccess,
                extra: {
                  'title': isUpdate
                      ? 'Purchase Order has been updated'
                      : 'New purchase order has been added',
                },
              );
              if (changed == true && context.mounted) {
                context.pop(true);
              }
            }
          },
          child: BlocBuilder<PurchaseOrderFormCubit, PurchaseOrderFormReq>(
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        PurchaseOrderButton(
                          isUpdate: isUpdate,
                          title: 'Project',
                          selectedTitle: state.type.title,
                        ),
                        SizedBox(width: 14),
                        PurchaseOrderButton(
                          isUpdate: isUpdate,
                          title: 'Aftersales',
                          selectedTitle: state.type.title,
                        ),
                        SizedBox(width: 14),
                        PurchaseOrderButton(
                          isUpdate: isUpdate,
                          title: 'Stock',
                          selectedTitle: state.type.title,
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            state.type.title == 'Project'
                                ? PurchaseOrderFormProjectWidget(state: state)
                                : PurchaseOrderFormStockWidget(state: state),
                            SizedBox(height: 50),
                            ActionButtonWidget(
                              onPressed: () {
                                final isValid =
                                    _formKey.currentState?.validate() ?? false;
                                if (!isValid) return;

                                context.read<ActionButtonCubit>().execute(
                                  usecase: isUpdate
                                      ? UpdatePurchaseOrderUseCase()
                                      : AddPurchaseOrderUseCase(),
                                  params: context
                                      .read<PurchaseOrderFormCubit>()
                                      .state,
                                );
                              },
                              title: isUpdate
                                  ? 'Update Purchase Order'
                                  : 'Create Purchase Order',
                              fontSize: 16,
                            ),
                            SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
