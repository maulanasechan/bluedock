import 'package:bluedock/features/product/domain/entities/sperre_air_system_solutions_entity.dart';

class SperreAirSystemSolutionsReq {
  final String productId;
  final String productUsage;
  final String productCategory;
  final String productName;
  final String productExplanation;
  final List<String> favorites;
  final int quantity;
  final String image;

  const SperreAirSystemSolutionsReq({
    this.productId = '',
    this.productUsage = '',
    this.productCategory = '',
    this.productName = '',
    this.productExplanation = '',
    this.favorites = const <String>[],
    this.quantity = 0,
    this.image = '',
  });

  SperreAirSystemSolutionsReq copyWith({
    String? productId,
    String? productUsage,
    String? productCategory,
    String? productName,
    String? productExplanation,
    List<String>? favorites,
    int? quantity,
    String? image,
  }) {
    return SperreAirSystemSolutionsReq(
      productId: productId ?? this.productId,
      productUsage: productUsage ?? this.productUsage,
      productCategory: productCategory ?? this.productCategory,
      productName: productName ?? this.productName,
      productExplanation: productExplanation ?? this.productExplanation,
      favorites: favorites ?? this.favorites,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
    );
  }
}

extension SperreAirSystemSolutionsXReq on SperreAirSystemSolutionsReq {
  SperreAirSystemSolutionsEntity toEntity() {
    return SperreAirSystemSolutionsEntity(
      productId: productId,
      productUsage: productUsage,
      productCategory: productCategory,
      productName: productName,
      productExplanation: productExplanation,
      favorites: favorites,
      quantity: quantity,
      image: image,
    );
  }
}
