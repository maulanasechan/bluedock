import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/product/domain/entities/product_categories_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductCategoryCardWidget extends StatelessWidget {
  final ProductCategoriesEntity product;
  const ProductCategoryCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(product.route, extra: product.productCategoriesId);
      },
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.maxFinite,
          height: 72,
          padding: EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.white,
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset(product.image, fit: BoxFit.contain),
                  ),
                  SizedBox(width: 14),
                  SizedBox(
                    width: 200,
                    child: TextWidget(
                      overflow: TextOverflow.fade,
                      text: product.title,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    text: 'Total Product',
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                  SizedBox(height: 6),
                  TextWidget(
                    text: '${product.totalProduct.toInt()} Products',
                    color: AppColors.blue,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
