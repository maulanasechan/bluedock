import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/search_textfield_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/invoice/presentation/bloc/invoice_display_cubit.dart';
import 'package:bluedock/features/invoice/presentation/bloc/invoice_display_state.dart';
import 'package:bluedock/features/invoice/presentation/widgets/invoice_card_slideable_widget.dart';
import 'package:bluedock/features/project/presentation/widgets/project_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageInvoicePage extends StatelessWidget {
  const ManageInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InvoiceDisplayCubit()..displayInitial(),
        ),
        BlocProvider(create: (context) => ActionButtonCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: 'Manage Invoice',
        padding: EdgeInsets.fromLTRB(0, 90, 0, 24),
        body: Column(
          children: [
            BlocBuilder<InvoiceDisplayCubit, InvoiceDisplayState>(
              builder: (context, state) {
                final type = context.read<InvoiceDisplayCubit>().currentType;
                final selectedLabel = (type.isEmpty)
                    ? 'All'
                    : '${type[0].toUpperCase()}${type.substring(1)}';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchTextfieldWidget(
                      withFilter: true,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          context.read<InvoiceDisplayCubit>().displayInitial();
                        } else {
                          context.read<InvoiceDisplayCubit>().setKeyword(value);
                        }
                      },
                      listFilter: const [
                        'All',
                        'Down Payment',
                        'Letter of Contract',
                      ],
                      selected: selectedLabel,
                      onSelected: (value) {
                        final mapped = value == 'All' ? '' : value;
                        context.read<InvoiceDisplayCubit>().setType(mapped);
                      },
                    ),
                    SizedBox(height: selectedLabel != 'All' ? 20 : 12),
                    if (selectedLabel != 'All')
                      Row(
                        children: [
                          TextWidget(
                            text: 'Invoice Status :',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(width: 6),
                          TextWidget(
                            text: selectedLabel,
                            fontWeight: FontWeight.w700,
                            color: selectedLabel == 'Down Payment'
                                ? AppColors.blue
                                : AppColors.orange,
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
            SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<InvoiceDisplayCubit, InvoiceDisplayState>(
                builder: (context, state) {
                  if (state is InvoiceDisplayLoading) {
                    return ProjectLoadingWidget();
                  }
                  if (state is InvoiceDisplayFetched) {
                    if (state.listInvoice.isEmpty) {
                      return Center(
                        child: TextWidget(text: "There isn't any invoice."),
                      );
                    } else {
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return InvoiceCardSlideableWidget(
                            invoice: state.listInvoice[index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 12);
                        },
                        itemCount: state.listInvoice.length,
                      );
                    }
                  }
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
