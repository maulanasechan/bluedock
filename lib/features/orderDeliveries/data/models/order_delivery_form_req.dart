import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';

class OrderDeliveryFormReq {
  // IDs & linkage
  final String deliveryOrderId;
  final PurchaseOrderEntity? purchaseOrder;

  // Tracking & documents
  final String? trackingId;
  final String? blNumber;

  // Dates (nullable saat form, diisi saat submit)
  final DateTime? deliveryDate; // ETD / target kirim
  final DateTime? estimatedDate; // ETA / target tiba

  // Money
  final String currency;
  final int? price; // nullable

  // Parties & locations (simple)
  final String shipperCompany;
  final String shipperContact;
  final String dischargeLocation; // origin / pelabuhan asal
  final String arrivalLocation; // destination / pelabuhan tujuan

  // Items
  final List<InventoryEntity> listComponent;
  final List<int> listQuantity;
  final int componentLength; // utk kontrol baris di UI

  // Meta
  final List<String> searchKeywords;
  final List<String> favorites;
  final String status; // e.g. Active/Draft/...
  final String type; // e.g. inbound/outbound

  const OrderDeliveryFormReq({
    // IDs & linkage
    this.deliveryOrderId = '',
    this.purchaseOrder,

    // Tracking & documents
    this.trackingId,
    this.blNumber,

    // Dates
    this.deliveryDate,
    this.estimatedDate,

    // Money
    this.currency = 'USD',
    this.price,

    // Parties & locations
    this.shipperCompany = '',
    this.shipperContact = '',
    this.dischargeLocation = '',
    this.arrivalLocation = '',

    // Items
    this.listComponent = const <InventoryEntity>[],
    this.listQuantity = const <int>[],
    this.componentLength = 1,

    // Meta
    this.searchKeywords = const <String>[],
    this.favorites = const <String>[],
    this.status = 'Active',
    this.type = 'Inbound',
  });

  OrderDeliveryFormReq copyWith({
    // IDs & linkage
    String? deliveryOrderId,
    PurchaseOrderEntity? purchaseOrder,

    // Tracking & documents (pakai sentinel supaya bisa set null)
    Object? trackingId = _unset,
    Object? blNumber = _unset,

    // Dates
    Object? deliveryDate = _unset, // Timestamp? atau null
    Object? estimatedDate = _unset, // Timestamp? atau null
    // Money
    String? currency,
    Object? price = _unset, // int? atau null
    // Parties & locations
    String? shipperCompany,
    String? shipperContact,
    String? dischargeLocation,
    String? arrivalLocation,

    // Items
    List<InventoryEntity>? listComponent,
    List<int>? listQuantity,
    int? componentLength,

    // Meta
    List<String>? searchKeywords,
    List<String>? favorites,
    String? status,
    String? type,
  }) {
    return OrderDeliveryFormReq(
      // IDs & linkage
      deliveryOrderId: deliveryOrderId ?? this.deliveryOrderId,
      purchaseOrder: purchaseOrder ?? this.purchaseOrder,

      // Tracking & documents
      trackingId: identical(trackingId, _unset)
          ? this.trackingId
          : trackingId as String?,
      blNumber: identical(blNumber, _unset)
          ? this.blNumber
          : blNumber as String?,

      // Dates
      deliveryDate: identical(deliveryDate, _unset)
          ? this.deliveryDate
          : deliveryDate as DateTime?,
      estimatedDate: identical(estimatedDate, _unset)
          ? this.estimatedDate
          : estimatedDate as DateTime?,

      // Money
      currency: currency ?? this.currency,
      price: identical(price, _unset) ? this.price : price as int?,

      // Parties & locations
      shipperCompany: shipperCompany ?? this.shipperCompany,
      shipperContact: shipperContact ?? this.shipperContact,
      dischargeLocation: dischargeLocation ?? this.dischargeLocation,
      arrivalLocation: arrivalLocation ?? this.arrivalLocation,

      // Items
      listComponent: listComponent ?? this.listComponent,
      listQuantity: listQuantity ?? this.listQuantity,
      componentLength: componentLength ?? this.componentLength,

      // Meta
      searchKeywords: searchKeywords ?? this.searchKeywords,
      favorites: favorites ?? this.favorites,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }

  static const Object _unset = Object();
}
