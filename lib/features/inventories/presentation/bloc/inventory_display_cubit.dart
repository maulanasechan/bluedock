import 'package:bluedock/common/domain/entities/product_category_entity.dart';
import 'package:bluedock/common/domain/entities/product_selection_entity.dart';
import 'package:bluedock/features/inventories/data/models/search_inventory_req.dart';
import 'package:bluedock/features/inventories/domain/usecases/get_inventory_by_id_usecase.dart';
import 'package:bluedock/features/inventories/domain/usecases/search_inventory_usecase.dart';
import 'package:bluedock/features/inventories/presentation/bloc/inventory_display_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryDisplayCubit extends Cubit<InventoryDisplayState> {
  InventoryDisplayCubit() : super(InventoryDisplayInitial());

  int _reqId = 0;

  // ✅ filter internal selalu string ("" = no filter)
  String _category = '';
  String _categoryId = '';
  String _model = '';
  String _modelId = '';
  String _keyword = '';

  // optional getter
  String get currentCategoryId => _categoryId;
  String get currentCategory => _category;
  String get currentModelId => _modelId;
  String get currentModel => _model;
  String get currentKeyword => _keyword;

  // Boleh dipanggil tanpa params; kalau ada params, sync dulu internal filter
  Future<void> displayInventory({SearchInventoryReq? params}) async {
    if (params != null) {
      _categoryId = params.category.trim();
      _modelId = params.model.trim();
      _keyword = params.keyword.trim();
    }

    final myReq = ++_reqId;
    emit(InventoryDisplayLoading());

    final req = SearchInventoryReq(
      category: _categoryId,
      model: _modelId,
      keyword: _keyword,
    );
    final returnedData = await sl<SearchInventoryUseCase>().call(params: req);

    if (myReq != _reqId) return; // race guard

    returnedData.fold(
      (error) => emit(InventoryDisplayFailure(message: error.toString())),
      (data) => emit(InventoryDisplayFetched(listInventory: data)),
    );
  }

  // Awal: boleh tanpa argumen ("" = all)
  void displayInitial([String? category, String? model]) {
    _categoryId = (category ?? '').trim();
    _modelId = (model ?? '').trim();
    _keyword = '';
    displayInventory(); // pakai filter internal
  }

  // Set dari action button
  void setCategory(ProductCategoryEntity? entity) {
    _categoryId = ((entity?.categoryId ?? entity?.categoryId) ?? '')
        .toString()
        .trim();
    _category = ((entity?.title ?? entity?.title) ?? '').toString().trim();
    displayInventory();
  }

  void setModel(ProductSelectionEntity? entity) {
    _modelId = ((entity?.productId ?? entity?.productId) ?? '')
        .toString()
        .trim();
    _model = ((entity?.productModel ?? entity?.productModel) ?? '')
        .toString()
        .trim();
    displayInventory();
  }

  // Toggle: tekan type yang sama untuk clear (jadi "")
  void toggleCategory(String category) {
    final c = category.trim();
    _category = _category == c ? '' : c;
    displayInventory();
  }

  void toggleModel(String model) {
    final m = model.trim();
    _model = _model == m ? '' : m;
    displayInventory();
  }

  // Set keyword dari search box
  void setKeyword(String? keyword) {
    _keyword = (keyword ?? '').trim();
    displayInventory();
  }

  // Clear semua filter
  void clearFilters() {
    _categoryId = '';
    _modelId = '';
    _keyword = '';
    displayInventory();
  }

  Future<void> displayInventoryById(String inventoryId) async {
    final myReq = ++_reqId;
    emit(InventoryDisplayLoading());

    final result = await sl<GetInventoryByIdUseCase>().call(
      params: inventoryId,
    );

    if (myReq != _reqId) return;

    result.fold(
      (err) => emit(InventoryDisplayFailure(message: err.toString())),
      (inventory) => emit(InventoryDisplayOneFetched(inventory: inventory)),
    );
  }
}
