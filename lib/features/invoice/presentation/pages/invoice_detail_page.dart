import 'package:bluedock/common/helper/stringTrimmer/format_thousand_helper.dart';
import 'package:bluedock/common/helper/waitAction/wait_action_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/copy_button_widget.dart';
import 'package:bluedock/common/widgets/button/widgets/icon_button_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/assets/app_images.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/invoice/domain/entities/invoice_entity.dart';
import 'package:bluedock/features/invoice/presentation/bloc/invoice_display_cubit.dart';
import 'package:bluedock/features/invoice/presentation/bloc/invoice_display_state.dart';
import 'package:bluedock/features/project/domain/usecases/delete_project_usecase.dart';
import 'package:bluedock/features/project/presentation/widgets/project_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class InvoiceDetailPage extends StatelessWidget {
  final String invoiceId;
  const InvoiceDetailPage({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (context) =>
              InvoiceDisplayCubit()..displayInvoiceById(invoiceId),
        ),
      ],
      child: GradientScaffoldWidget(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 90, 0, 0),
          child: BlocBuilder<InvoiceDisplayCubit, InvoiceDisplayState>(
            builder: (context, state) {
              if (state is InvoiceDisplayLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is InvoiceDisplayOneFetched) {
                final invoice = state.invoice;
                return Column(
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButtonWidget(),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: _avatarWidget(context, invoice),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _contentWidget(invoice),
                            _bottomNavWidget(context, invoice),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _avatarWidget(BuildContext context, InvoiceEntity invoice) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Image.asset(
            invoice.productSelection.image == ''
                ? AppImages.appDetegasaIncenerator
                : invoice.productSelection.image,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 24),
        TextWidget(
          text: invoice.purchaseContractNumber,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        SizedBox(height: 14),
        ButtonWidget(
          width: 150,
          height: 40,
          onPressed: () {
            context.pushNamed(
              AppRoutes.projectDetail,
              extra: invoice.projectId,
            );
          },
          title: 'See Project Detail',
          background: AppColors.blue,
          fontSize: 14,
        ),
      ],
    );
  }

  Widget _contentWidget(InvoiceEntity invoice) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      child: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Project Name',
                      subTitle: invoice.projectName,
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Project Code',
                    subTitle: invoice.projectCode,
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Customer Company',
                      subTitle: invoice.customerCompany,
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Issued Date',
                    subTitle: DateFormat(
                      'dd MMM yyyy, HH:mm',
                    ).format(invoice.issuedDate!.toDate()),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProjectTextWidget(
                    title: 'Customer Contact',
                    subTitle:
                        '${invoice.customerName} - ${invoice.customerContact}',
                  ),
                  CopyButtonWidget(text: invoice.customerContact),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Total Price',
                      subTitle:
                          '${invoice.currency} ${formatWithCommas(invoice.totalPrice.toString())}',
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Quantity',
                    subTitle: invoice.quantity.toString(),
                  ),
                ],
              ),

              Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'DP Price',
                      subTitle:
                          '${invoice.currency} ${formatWithCommas(invoice.dpAmount.toString())}',
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'LC Price',
                    subTitle:
                        '${invoice.currency} ${formatWithCommas(invoice.lcAmount.toString())}',
                  ),
                ],
              ),

              Row(
                children: [
                  SizedBox(
                    width: 155,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: 'DP Status',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: invoice.dpStatus == false
                                ? AppColors.red
                                : AppColors.blue,
                          ),
                          child: TextWidget(
                            text: invoice.dpStatus ? 'Paid' : 'Unpaid',
                            fontSize: 16,
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'LC Status',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: invoice.lcStatus == false
                              ? AppColors.red
                              : AppColors.blue,
                        ),
                        child: TextWidget(
                          text: invoice.lcStatus ? 'Paid' : 'Unpaid',
                          fontSize: 16,
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 155,
                    child: ProjectTextWidget(
                      title: 'Created By',
                      subTitle: invoice.createdBy,
                      bottom: 0,
                    ),
                  ),
                  SizedBox(width: 30),
                  ProjectTextWidget(
                    title: 'Created At',
                    subTitle: DateFormat(
                      'dd MMM yyyy, HH:mm',
                    ).format(invoice.createdAt.toDate()),
                    bottom: 0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavWidget(BuildContext context, InvoiceEntity invoice) {
    return Builder(
      builder: (context) {
        return Column(
          children: [
            SizedBox(height: 50),
            ButtonWidget(
              onPressed: () async {
                final actionCubit = context.read<ActionButtonCubit>();
                final changed = await CenterModalWidget.display(
                  context: context,
                  yesButtonColor: AppColors.green,
                  title: invoice.dpStatus
                      ? 'Letter of Contract Paid'
                      : 'Down Payment Paid',
                  subtitle:
                      "Are you sure this ${invoice.projectName} had been paid the Down Payment?",
                  yesButton: 'Paid',
                  actionCubit: actionCubit,
                  yesButtonOnTap: () async {
                    actionCubit.execute(
                      usecase: DeleteProjectUseCase(),
                      params: invoice,
                    );
                    final ok = await waitActionDone(actionCubit);
                    if (ok && context.mounted) context.pop(true);
                  },
                );
                if (changed == true && context.mounted) {
                  final change = await context.pushNamed(
                    AppRoutes.successInvoice,
                    extra:
                        '${invoice.dpStatus ? "Letter of Contract" : "Down Payment"} for ${invoice.projectName} has been paid',
                  );

                  if (change == true && context.mounted) {
                    context.pop(true);
                  }
                }
              },
              background: invoice.dpStatus ? AppColors.green : AppColors.blue,
              title: invoice.dpStatus
                  ? 'Letter of Contract Paid'
                  : 'Down Payment Paid',
              fontSize: 16,
            ),
            SizedBox(height: 6),
          ],
        );
      },
    );
  }
}
