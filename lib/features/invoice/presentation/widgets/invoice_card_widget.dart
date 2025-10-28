import 'package:bluedock/common/helper/color/string_to_color_helper.dart';
import 'package:bluedock/common/widgets/card/card_container_with_type_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/invoice/domain/entities/invoice_entity.dart';
import 'package:bluedock/features/invoice/domain/usecases/favorite_invoice_usecase.dart';
import 'package:bluedock/features/invoice/presentation/bloc/invoice_display_cubit.dart';
import 'package:bluedock/features/product/presentation/widgets/title_subtitle_widget.dart';
import 'package:bluedock/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class InvoiceCardWidget extends StatelessWidget {
  final InvoiceEntity invoice;
  const InvoiceCardWidget({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isFav = uid != null && invoice.favorites.contains(uid);

    return CardContainerWithTypeWidget(
      typeColor: invoice.type.color,
      onTap: () async {
        final changed = await context.pushNamed(
          AppRoutes.invoiceDetail,
          extra: {'id': invoice.invoiceId, 'isEdit': true},
        );
        if (changed == true && context.mounted) {
          context.read<InvoiceDisplayCubit>().displayInitial();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 155,
                child: Row(
                  children: [
                    SizedBox(
                      width: 26,
                      height: 26,
                      child: Image.asset(
                        invoice.type.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 8),
                    TextWidget(
                      text: invoice.type.title,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: parseHexColor(invoice.type.color),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 30),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: DateFormat(
                        'dd MMM yyyy',
                      ).format(invoice.issuedDate!.toDate()),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final cubit = context.read<InvoiceDisplayCubit>();
                        final res = await sl<FavoriteInvoiceUseCase>().call(
                          params: invoice.invoiceId,
                        );

                        if (!context.mounted) return;

                        final changed = res.isRight();
                        if (changed) {
                          cubit.displayInitial();
                        }
                      },
                      child: PhosphorIcon(
                        isFav
                            ? PhosphorIconsFill.heart
                            : PhosphorIconsBold.heart,
                        color: AppColors.orange,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 155,
                child: TitleSubtitleWidget(
                  title: 'Project Name',
                  subtitle: invoice.projectName,
                ),
              ),
              SizedBox(width: 30),
              TitleSubtitleWidget(
                title: 'Project Code',
                subtitle: invoice.projectCode,
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 155,
                child: TitleSubtitleWidget(
                  title: 'Custommer Company',
                  subtitle: invoice.customerCompany,
                ),
              ),
              SizedBox(width: 30),
              TitleSubtitleWidget(
                title: 'Custommer Contact',
                subtitle:
                    '${invoice.customerName} - ${invoice.customerContact}',
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 155,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: 'Down Payment Status',
                      fontSize: 12,
                      overflow: TextOverflow.fade,
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
                        fontSize: 12,
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
                    text: 'Letter of Contract Status',
                    fontSize: 12,
                    overflow: TextOverflow.fade,
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: invoice.lcStatus == false
                          ? AppColors.red
                          : AppColors.blue,
                    ),
                    child: TextWidget(
                      text: invoice.lcStatus ? 'Paid' : 'Unpaid',
                      fontSize: 12,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
