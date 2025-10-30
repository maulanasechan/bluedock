import 'package:bluedock/features/purchaseOrders/domain/entities/purchase_order_entity.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDeliveryEntity {
  // IDs & linkage
  final String deliveryOrderId;
  final PurchaseOrderEntity? purchaseOrder;

  // Tracking & documents
  final String? trackingId;
  final String? blNumber;

  // Dates
  final Timestamp deliveryDate; // ETD / target kirim
  final Timestamp estimatedDate; // ETA / target tiba

  // Money
  final String currency;
  final int? price;

  // Parties & locations (simple)
  final String shipperCompany;
  final String shipperContact;
  final String dischargeLocation; // origin / pelabuhan asal
  final String arrivalLocation; // destination / pelabuhan tujuan

  // Items
  final List<InventoryEntity> listComponent;
  final List<int> listQuantity;

  // Meta
  final List<String> searchKeywords;
  final List<String> favorites;
  final String status; // e.g. Draft/Confirmed/InTransit/Delivered/Cancelled
  final String type; // e.g. inbound/outbound

  // Audit
  final String createdBy;
  final Timestamp createdAt;
  final String? updatedBy;
  final Timestamp? updatedAt;

  OrderDeliveryEntity({
    // IDs & linkage
    required this.deliveryOrderId,
    required this.purchaseOrder,

    // Tracking & docs
    this.trackingId,
    this.blNumber,

    // Dates
    required this.deliveryDate,
    required this.estimatedDate,

    // Money
    required this.currency,
    this.price,

    // Parties & locations
    this.shipperCompany = '',
    this.shipperContact = '',
    this.dischargeLocation = '',
    this.arrivalLocation = '',

    // Items
    this.listComponent = const <InventoryEntity>[],
    required this.listQuantity,

    // Meta
    required this.searchKeywords,
    this.favorites = const <String>[],
    this.status = 'Active',
    required this.type,

    // Audit
    required this.createdBy,
    required this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  OrderDeliveryEntity copyWith({
    // IDs & linkage
    String? deliveryOrderId,
    PurchaseOrderEntity? purchaseOrder,

    // Tracking & docs
    Object? trackingId = _unset,
    Object? blNumber = _unset,

    // Dates
    Timestamp? deliveryDate,
    Timestamp? estimatedDate,

    // Money
    String? currency,
    Object? price = _unset,

    // Parties & locations
    String? shipperCompany,
    String? shipperContact,
    String? dischargeLocation,
    String? arrivalLocation,

    // Items
    List<InventoryEntity>? listComponent,
    List<int>? listQuantity,

    // Meta
    List<String>? searchKeywords,
    List<String>? favorites,
    String? status,
    String? type,

    // Audit
    String? createdBy,
    Timestamp? createdAt,
    Object? updatedBy = _unset,
    Object? updatedAt = _unset,
  }) {
    return OrderDeliveryEntity(
      // IDs & linkage
      deliveryOrderId: deliveryOrderId ?? this.deliveryOrderId,
      purchaseOrder: purchaseOrder ?? this.purchaseOrder,

      // Tracking & docs (pakai sentinel biar bisa set null)
      trackingId: identical(trackingId, _unset)
          ? this.trackingId
          : trackingId as String?,
      blNumber: identical(blNumber, _unset)
          ? this.blNumber
          : blNumber as String?,

      // Dates
      deliveryDate: deliveryDate ?? this.deliveryDate,
      estimatedDate: estimatedDate ?? this.estimatedDate,

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

      // Meta
      searchKeywords: searchKeywords ?? this.searchKeywords,
      favorites: favorites ?? this.favorites,
      status: status ?? this.status,
      type: type ?? this.type,

      // Audit (pakai sentinel untuk nullable)
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedBy: identical(updatedBy, _unset)
          ? this.updatedBy
          : updatedBy as String?,
      updatedAt: identical(updatedAt, _unset)
          ? this.updatedAt
          : updatedAt as Timestamp?,
    );
  }

  static const Object _unset = Object();
}
