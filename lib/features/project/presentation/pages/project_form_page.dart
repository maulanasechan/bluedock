import 'package:bluedock/common/bloc/productSection/product_section_cubit.dart';
import 'package:bluedock/common/bloc/staff/staff_display_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/selection/item_selection_modal_widget.dart';
import 'package:bluedock/common/widgets/selection/staff_selection_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/project/data/models/project_form_req.dart';
import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:bluedock/features/project/domain/usecases/add_project_usecase.dart';
import 'package:bluedock/features/project/domain/usecases/update_project_usecase.dart';
import 'package:bluedock/features/project/presentation/bloc/project_form_cubit.dart';
import 'package:bluedock/common/widgets/selection/product_category_selection_widget.dart';
import 'package:bluedock/common/widgets/selection/product_selection_widget.dart';
import 'package:bluedock/common/bloc/itemSelection/item_selection_display_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProjectFormPage extends StatelessWidget {
  final ProjectEntity? project;
  ProjectFormPage({super.key, this.project});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isUpdate = project != null;
    final collection = 'Projects';
    final document = 'Selection';

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (_) {
            final c = ProjectFormCubit();
            if (isUpdate) c.hydrateFromEntity(project!);
            return c;
          },
        ),
        BlocProvider(create: (context) => ProductSectionCubit()),
        BlocProvider(create: (context) => ItemSelectionDisplayCubit()),
        BlocProvider(create: (context) => StaffDisplayCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: isUpdate ? 'Update Project' : 'Add Project',
        body: BlocListener<ActionButtonCubit, ActionButtonState>(
          listener: (context, state) async {
            if (state is ActionButtonFailure) {
              var snackbar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ActionButtonSuccess) {
              final changed = await context.pushNamed(
                AppRoutes.successProject,
                extra: {
                  'title': isUpdate
                      ? 'Project has been updated'
                      : 'New project has been added',
                },
              );
              if (changed == true && context.mounted) {
                context.pop(true);
              }
            }
          },
          child: SingleChildScrollView(
            child: BlocBuilder<ProjectFormCubit, ProjectFormReq>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextfieldWidget(
                        validator: AppValidators.required(
                          field: 'Purchase Contract Number',
                        ),
                        hintText: 'Purchase Contract Number',
                        title: 'Purchase Contract Number',
                        initialValue: state.purchaseContractNumber,
                        suffixIcon: PhosphorIconsBold.cardholder,
                        onChanged: (v) => context
                            .read<ProjectFormCubit>()
                            .setPurchaseContractNumber(v),
                      ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        validator: AppValidators.required(
                          field: 'Project Name',
                        ),
                        hintText: 'Project Name',
                        title: 'Project Name',
                        initialValue: state.projectName,
                        suffixIcon: PhosphorIconsBold.cardsThree,
                        onChanged: (v) =>
                            context.read<ProjectFormCubit>().setProjectName(v),
                      ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        validator: AppValidators.required(
                          field: 'Project Code',
                        ),
                        hintText: 'Project Code',
                        title: 'Project Code',
                        initialValue: state.projectCode,
                        suffixIcon: PhosphorIconsBold.keyboard,
                        onChanged: (v) =>
                            context.read<ProjectFormCubit>().setProjectCode(v),
                      ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        validator: AppValidators.required(
                          field: 'Customer Company',
                        ),
                        hintText: 'Customer Company',
                        title: 'Customer Company',
                        initialValue: state.customerCompany,
                        suffixIcon: PhosphorIconsBold.buildingOffice,
                        onChanged: (v) => context
                            .read<ProjectFormCubit>()
                            .setCustomerCompany(v),
                      ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        validator: AppValidators.required(
                          field: 'Customer Name',
                        ),
                        hintText: 'Customer Name',
                        title: 'Customer Name',
                        initialValue: state.customerName,
                        suffixIcon: PhosphorIconsBold.addressBookTabs,
                        onChanged: (v) =>
                            context.read<ProjectFormCubit>().setCustomerName(v),
                      ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        validator: AppValidators.number(),
                        hintText: 'Customer Contact',
                        title: 'Customer Contact',
                        initialValue: state.customerContact,
                        suffixIcon: PhosphorIconsBold.phoneCall,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(12),
                        ],
                        onChanged: (v) => context
                            .read<ProjectFormCubit>()
                            .setCustomerContact(v),
                      ),
                      SizedBox(height: 24),
                      ProductCategorySelectionWidget(
                        title: 'Product Category',
                        selected: state.productCategory?.title ?? '',
                        onPressed: (value) {
                          context.read<ProjectFormCubit>().setProductCategory(
                            value,
                          );
                          context.pop();
                        },
                        extraProviders: [
                          BlocProvider.value(
                            value: context.read<ProjectFormCubit>(),
                          ),
                        ],
                        icon: PhosphorIconsBold.archive,
                      ),
                      SizedBox(height: 24),
                      ProductSelectionWidget(
                        title: 'Product Model',
                        categoryId: state.productCategory?.categoryId ?? '',
                        selected: state.productSelection?.productModel ?? '',
                        onPressed: (value) {
                          context.read<ProjectFormCubit>().setProductSelection(
                            value,
                          );
                          context.pop();
                        },
                        extraProviders: [
                          BlocProvider.value(
                            value: context.read<ProjectFormCubit>(),
                          ),
                        ],
                        icon: PhosphorIconsBold.washingMachine,
                      ),
                      SizedBox(height: 24),
                      StaffSelectionWidget(
                        title: 'Team',
                        selected: state.listTeam,
                        onPressed: (value) {
                          context.read<ProjectFormCubit>().toggleTeamByEntity(
                            value,
                          );
                        },
                        extraProviders: [
                          BlocProvider.value(
                            value: context.read<ProjectFormCubit>(),
                          ),
                        ],
                        icon: PhosphorIconsBold.userList,
                      ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        validator: AppValidators.number(),
                        hintText: 'Product Quantity',
                        title: 'Product Quantity',
                        initialValue: state.quantity.toString(),
                        suffixIcon: PhosphorIconsBold.package,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (v) => context
                            .read<ProjectFormCubit>()
                            .setQuantity(int.parse(v)),
                      ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        hintText: 'Project Description',
                        title: 'Project Description',
                        initialValue: state.projectDescription,
                        suffixIcon: PhosphorIconsBold.keyboard,
                        maxLines: 4,
                        onChanged: (v) => context
                            .read<ProjectFormCubit>()
                            .setProjectDescription(v),
                      ),
                      SizedBox(height: 24),
                      TextWidget(
                        text: 'Price and Currency',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 65,
                            child: ItemSelectionModalWidget(
                              withoutIcon: true,
                              withoutTitle: true,
                              align: TextAlign.center,
                              collection: collection,
                              document: document,
                              subCollection: 'Currency',
                              selected: state.currency,
                              icon: PhosphorIconsBold.creditCard,
                              onSelected: (value) {
                                context.read<ProjectFormCubit>().setCurrency(
                                  value.title,
                                );
                                context.pop();
                              },
                              extraProviders: [
                                BlocProvider.value(
                                  value: context.read<ProjectFormCubit>(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextfieldWidget(
                              validator: AppValidators.number(),
                              hintText: 'Price',
                              initialValue: state.price == null
                                  ? ''
                                  : state.price.toString(),
                              suffixIcon: PhosphorIconsBold.moneyWavy,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (v) =>
                                  context.read<ProjectFormCubit>().setPrice(v),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      ItemSelectionModalWidget(
                        collection: collection,
                        document: document,
                        subCollection: 'Payment',
                        selected: state.payment,
                        icon: PhosphorIconsBold.wallet,
                        onSelected: (value) {
                          context.read<ProjectFormCubit>().setPayment(
                            value.title,
                          );
                          context.pop();
                        },
                        extraProviders: [
                          BlocProvider.value(
                            value: context.read<ProjectFormCubit>(),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      ItemSelectionModalWidget(
                        collection: collection,
                        heightButton: 60,
                        document: document,
                        subCollection: 'Warranty of Goods',
                        selected: state.warrantyOfGoods,
                        icon: PhosphorIconsBold.heartbeat,
                        onSelected: (value) {
                          context.read<ProjectFormCubit>().setWarrantyOfGoods(
                            value.title,
                          );
                          context.pop();
                        },
                        extraProviders: [
                          BlocProvider.value(
                            value: context.read<ProjectFormCubit>(),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      TextWidget(
                        text: 'Maintenance Period',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextfieldWidget(
                              validator: AppValidators.number(),
                              hintText: 'Maintenance Period',
                              initialValue: state.maintenancePeriod == null
                                  ? ''
                                  : state.maintenancePeriod.toString(),
                              suffixIcon: PhosphorIconsBold.calendarCheck,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (v) => context
                                  .read<ProjectFormCubit>()
                                  .setMaintenancePeriod(v),
                            ),
                          ),
                          SizedBox(width: 12),
                          SizedBox(
                            width: 80,
                            child: ItemSelectionModalWidget(
                              icon: PhosphorIconsBold.addressBook,
                              align: TextAlign.center,
                              withoutIcon: true,
                              withoutTitle: true,
                              collection: collection,
                              document: document,
                              subCollection: 'Maintenance Currency',
                              selected: state.maintenanceCurrency,
                              onSelected: (value) {
                                context
                                    .read<ProjectFormCubit>()
                                    .setMaintenanceCurrency(value.title);
                                context.pop();
                              },
                              extraProviders: [
                                BlocProvider.value(
                                  value: context.read<ProjectFormCubit>(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      ItemSelectionModalWidget(
                        collection: collection,
                        document: document,
                        subCollection: 'Delivery',
                        selected: state.delivery,
                        icon: PhosphorIconsBold.heartbeat,
                        onSelected: (value) {
                          context.read<ProjectFormCubit>().setDelivery(
                            value.title,
                          );
                          context.pop();
                        },
                        extraProviders: [
                          BlocProvider.value(
                            value: context.read<ProjectFormCubit>(),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      ActionButtonWidget(
                        onPressed: () {
                          final isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (!isValid) return;

                          context.read<ActionButtonCubit>().execute(
                            usecase: isUpdate
                                ? UpdateProjectUseCase()
                                : AddProjectUseCase(),
                            params: context.read<ProjectFormCubit>().state,
                          );
                        },
                        title: isUpdate ? 'Update Project' : 'Add New Project',
                        fontSize: 16,
                      ),
                      SizedBox(height: 6),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
