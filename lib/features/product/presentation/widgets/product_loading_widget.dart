import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductLoadingWidget extends StatelessWidget {
  const ProductLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.baseLoading,
      highlightColor: AppColors.highlightLoading,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) {
          return SizedBox(height: 18);
        },
        itemBuilder: (context, index) {
          return Container(
            width: double.maxFinite,
            height: 150,
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
