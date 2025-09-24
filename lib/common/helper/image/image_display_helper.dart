import 'package:bluedock/core/constants/app_url_constant.dart';

class ImageDisplayHelper {
  static generateCategoryImageUrl(String title) {
    return AppUrlConstant.categoryImage + title + AppUrlConstant.alt;
  }

  static generateProductImageUrl(String title) {
    return AppUrlConstant.productImage + title + AppUrlConstant.alt;
  }
}
