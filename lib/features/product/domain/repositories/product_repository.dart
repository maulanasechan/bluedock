import 'package:bluedock/features/product/data/models/product/product_req.dart';
import 'package:bluedock/features/product/data/models/selection/selection_req.dart';
import 'package:bluedock/features/product/data/models/sperreAirCompressor/sperre_air_compressor_form_req.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either> getProductCategories();

  //Sperre Air Compressor
  Future<Either> searchSperreAirCompressor(String query);
  Future<Either> addSperreAirCompressor(SperreAirCompressorReq product);
  Future<Either> updateSperreAirCompressor(SperreAirCompressorReq product);
  Future<Either> deleteProduct(ProductReq product);

  //Selection
  Future<Either> getSelection(SelectionReq selection);
}
