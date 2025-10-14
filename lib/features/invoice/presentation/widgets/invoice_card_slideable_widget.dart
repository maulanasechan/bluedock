import 'package:bluedock/common/helper/waitAction/wait_action_helper.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/card/slidable_action_widget.dart';
import 'package:bluedock/common/widgets/modal/center_modal_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/invoice/domain/entities/invoice_entity.dart';
import 'package:bluedock/features/invoice/presentation/widgets/invoice_card_widget.dart';
import 'package:bluedock/features/project/domain/usecases/delete_project_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class InvoiceCardSlideableWidget extends StatelessWidget {
  final InvoiceEntity invoice;
  const InvoiceCardSlideableWidget({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActionButtonCubit(),
      child: SlidableActionWidget(
        isSlideable:
            invoice.projectStatus == 'Inactive' && invoice.dpStatus == false
            ? true
            : invoice.projectStatus == 'Done' && invoice.dpStatus == false,
        isDeleted: false,
        extentRatio: 0.2,
        updateColor: invoice.dpStatus ? AppColors.green : AppColors.blue,
        updateIcon: PhosphorIconsFill.sealCheck,
        updateText: invoice.dpStatus ? 'LC Paid' : 'DP Paid',
        onUpdateTap: () async {
          final actionCubit = context.read<ActionButtonCubit>();
          final changed = await CenterModalWidget.display(
            yesButtonColor: AppColors.green,
            context: context,
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
        onDeleteTap: () async {},
        deleteParams: invoice.invoiceId,
        child: InvoiceCardWidget(invoice: invoice),
      ),
    );
  }
}
