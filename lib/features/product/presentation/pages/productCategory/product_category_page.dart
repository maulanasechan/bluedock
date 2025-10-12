import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/common/bloc/productSection/product_section_cubit.dart';
import 'package:bluedock/common/bloc/productSection/product_section_state.dart';
import 'package:bluedock/features/product/presentation/widgets/product_category_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ProductCategoryPage extends StatelessWidget {
  const ProductCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffoldWidget(
      hideBack: false,
      appbarTitle: 'Choose Category',
      body: BlocProvider(
        create: (context) => ProductSectionCubit()..displayProductCategories(),
        child: BlocBuilder<ProductSectionCubit, ProductSectionState>(
          builder: (context, state) {
            if (state is ProductSectionLoading) {
              return _productLoading();
            }
            if (state is ProductCategoryFetched) {
              return ListView.separated(
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8);
                },
                itemBuilder: (context, index) {
                  return ProductCategoryCardWidget(
                    product: state.productCategory[index],
                  );
                },
                itemCount: state.productCategory.length,
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  Widget _productLoading() {
    return Shimmer.fromColors(
      baseColor: AppColors.baseLoading,
      highlightColor: AppColors.highlightLoading,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) {
          return SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          return Container(
            width: double.maxFinite,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.red,
            ),
          );
        },
        itemCount: 8,
      ),
    );
  }
}
