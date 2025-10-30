import 'dart:convert';
import 'package:bluedock/features/orderDeliveries/domain/entities/order_delivery_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluedock/features/purchaseOrders/data/models/purchase_order_model.dart';
import 'package:bluedock/features/inventories/data/models/inventory_model.dart';

class OrderDeliveryModel {
  // IDs & linkage
  final String deliveryOrderId;
  final PurchaseOrderModel? purchaseOrder;

  // Tracking & docs
  final String? trackingId;
  final String? blNumber;

  // Dates
  final Timestamp deliveryDate; // ETD / target kirim
  final Timestamp estimatedDate; // ETA / target tiba

  // Money
  final String currency;
  final int? price;

  // Parties & locations
  final String shipperCompany;
  final String shipperContact;
  final String dischargeLocation; // origin
  final String arrivalLocation; // destination

  // Items
  final List<InventoryModel> listComponent;
  final List<int> listQuantity;

  // Meta
  final List<String> searchKeywords;
  final List<String> favorites;
  final String status; // e.g. Active/Draft/...
  final String type; // e.g. inbound/outbound

  // Audit
  final String createdBy;
  final Timestamp createdAt;
  final String? updatedBy;
  final Timestamp? updatedAt;

  const OrderDeliveryModel({
    // IDs & linkage
    required this.deliveryOrderId,
    this.purchaseOrder,

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
    this.listComponent = const <InventoryModel>[],
    required this.listQuantity,

    // Meta
    this.searchKeywords = const <String>[],
    this.favorites = const <String>[],
    this.status = 'Active',
    required this.type,

    // Audit
    required this.createdBy,
    required this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  OrderDeliveryModel copyWith({
    // IDs & linkage
    String? deliveryOrderId,
    PurchaseOrderModel? purchaseOrder,

    // Tracking & docs (pakai sentinel agar bisa set null)
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
    List<InventoryModel>? listComponent,
    List<int>? listQuantity,

    // Meta
    List<String>? searchKeywords,
    List<String>? favorites,
    String? status,
    String? type,

    // Audit
    String? createdBy,
    Timestamp? createdAt,
    String? updatedBy,
    Timestamp? updatedAt,
  }) {
    return OrderDeliveryModel(
      deliveryOrderId: deliveryOrderId ?? this.deliveryOrderId,
      purchaseOrder: purchaseOrder ?? this.purchaseOrder,

      trackingId: identical(trackingId, _unset)
          ? this.trackingId
          : trackingId as String?,
      blNumber: identical(blNumber, _unset)
          ? this.blNumber
          : blNumber as String?,

      deliveryDate: deliveryDate ?? this.deliveryDate,
      estimatedDate: estimatedDate ?? this.estimatedDate,

      currency: currency ?? this.currency,
      price: identical(price, _unset) ? this.price : price as int?,

      shipperCompany: shipperCompany ?? this.shipperCompany,
      shipperContact: shipperContact ?? this.shipperContact,
      dischargeLocation: dischargeLocation ?? this.dischargeLocation,
      arrivalLocation: arrivalLocation ?? this.arrivalLocation,

      listComponent: listComponent ?? this.listComponent,
      listQuantity: listQuantity ?? this.listQuantity,

      searchKeywords: searchKeywords ?? this.searchKeywords,
      favorites: favorites ?? this.favorites,
      status: status ?? this.status,
      type: type ?? this.type,

      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deliveryOrderId': deliveryOrderId,
      'purchaseOrder': purchaseOrder?.toMap(),
      'trackingId': trackingId,
      'blNumber': blNumber,
      'deliveryDate': deliveryDate,
      'estimatedDate': estimatedDate,
      'currency': currency,
      'price': price,
      'shipperCompany': shipperCompany,
      'shipperContact': shipperContact,
      'dischargeLocation': dischargeLocation,
      'arrivalLocation': arrivalLocation,
      'listComponent': listComponent.map((e) => e.toMap()).toList(),
      'listQuantity': listQuantity,
      'searchKeywords': searchKeywords,
      'favorites': favorites,
      'status': status,
      'type': type,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
    };
  }

  factory OrderDeliveryModel.fromMap(Map<String, dynamic> map) {
    List<String> asStringList(dynamic v) {
      if (v is List) return v.map((e) => e.toString()).toList();
      return const <String>[];
    }

    List<int> asIntList(dynamic v) {
      if (v is List) {
        final out = <int>[];
        for (final e in v) {
          if (e is int) {
            out.add(e);
          } else if (e is num) {
            out.add(e.toInt());
          } else if (e is String) {
            final p = int.tryParse(e);
            if (p != null) out.add(p);
          }
        }
        return out;
      }
      return const <int>[];
    }

    Map<String, dynamic> asMap(dynamic v) =>
        (v is Map) ? v.cast<String, dynamic>() : <String, dynamic>{};

    List<InventoryModel> parseComponents(dynamic v) {
      if (v is List) {
        return v
            .map((e) => InventoryModel.fromMap(asMap(e)))
            .toList(growable: false);
      }
      return const <InventoryModel>[];
    }

    PurchaseOrderModel? parsePurchaseOrder(dynamic v) =>
        v == null ? null : PurchaseOrderModel.fromMap(asMap(v));

    int? asIntOrNull(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    Timestamp asTimestampOrZero(dynamic v) {
      if (v is Timestamp) return v;
      return Timestamp(0, 0);
    }

    return OrderDeliveryModel(
      deliveryOrderId: (map['deliveryOrderId'] ?? '') as String,
      purchaseOrder: parsePurchaseOrder(map['purchaseOrder']),
      trackingId: map['trackingId'] as String?,
      blNumber: map['blNumber'] as String?,
      deliveryDate: asTimestampOrZero(map['deliveryDate']),
      estimatedDate: asTimestampOrZero(map['estimatedDate']),
      currency: (map['currency'] ?? '') as String,
      price: asIntOrNull(map['price']),
      shipperCompany: (map['shipperCompany'] ?? '') as String,
      shipperContact: (map['shipperContact'] ?? '') as String,
      dischargeLocation: (map['dischargeLocation'] ?? '') as String,
      arrivalLocation: (map['arrivalLocation'] ?? '') as String,
      listComponent: parseComponents(map['listComponent']),
      listQuantity: asIntList(map['listQuantity']),
      searchKeywords: asStringList(map['searchKeywords']),
      favorites: asStringList(map['favorites']),
      status: (map['status'] ?? 'Active') as String,
      type: (map['type'] ?? '') as String,
      createdBy: (map['createdBy'] ?? '') as String,
      createdAt: (map['createdAt'] as Timestamp?) ?? Timestamp(0, 0),
      updatedBy: map['updatedBy'] as String?,
      updatedAt: map['updatedAt'] as Timestamp?,
    );
  }

  String toJson() => json.encode(toMap());
  factory OrderDeliveryModel.fromJson(String source) =>
      OrderDeliveryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension OrderDeliveryXModel on OrderDeliveryModel {
  OrderDeliveryEntity toEntity() {
    return OrderDeliveryEntity(
      deliveryOrderId: deliveryOrderId,
      purchaseOrder: purchaseOrder?.toEntity(),
      trackingId: trackingId,
      blNumber: blNumber,
      deliveryDate: deliveryDate,
      estimatedDate: estimatedDate,
      currency: currency,
      price: price,
      shipperCompany: shipperCompany,
      shipperContact: shipperContact,
      dischargeLocation: dischargeLocation,
      arrivalLocation: arrivalLocation,
      listComponent: listComponent.map((m) => m.toEntity()).toList(),
      listQuantity: listQuantity,
      searchKeywords: searchKeywords,
      favorites: favorites,
      status: status,
      type: type,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedBy: updatedBy,
      updatedAt: updatedAt,
    );
  }
}

const Object _unset = Object();
