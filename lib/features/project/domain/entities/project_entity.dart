import 'package:bluedock/features/project/domain/entities/selection/product_selection_entity.dart';
import 'package:bluedock/features/project/domain/entities/selection/category_selection_entity.dart';
import 'package:bluedock/features/project/domain/entities/selection/staff_selection_entity.dart';

class ProjectEntity {
  final String projectId;
  final String invoiceId;
  final String purchaseContractNumber;
  final String projectName;
  final String projectCode;
  final String customerName;
  final String payment;
  final CategorySelectionEntity productCategory;
  final ProductSelectionEntity productSelection;
  final int price;
  final String currency;
  final String delivery;
  final String warrantyOfGoods;
  final int quantity;
  final String projectDescription;
  final int maintenancePeriod;
  final String maintenanceCurrency;
  final String customerContact;
  final List<String> favorites;
  final List<StaffSelectionEntity> listTeam;

  ProjectEntity({
    required this.projectId,
    required this.invoiceId,
    required this.purchaseContractNumber,
    required this.projectName,
    required this.projectCode,
    required this.customerName,
    required this.productCategory,
    required this.productSelection,
    required this.price,
    required this.currency,
    required this.delivery,
    required this.warrantyOfGoods,
    required this.quantity,
    required this.projectDescription,
    required this.maintenancePeriod,
    required this.maintenanceCurrency,
    required this.customerContact,
    required this.favorites,
    required this.listTeam,
    required this.payment,
  });

  ProjectEntity copyWith({
    String? projectId,
    String? invoiceId,
    String? purchaseContractNumber,
    String? projectName,
    String? projectCode,
    String? customerName,
    String? payment,
    List<String>? favorites,
    CategorySelectionEntity? productCategory,
    ProductSelectionEntity? productSelection,
    int? price,
    String? currency,
    String? delivery,
    String? warrantyOfGoods,
    int? quantity,
    String? projectDescription,
    int? maintenancePeriod,
    String? maintenanceCurrency,
    String? customerContact,
    List<StaffSelectionEntity>? listTeam,
  }) {
    return ProjectEntity(
      projectId: projectId ?? this.projectId,
      invoiceId: invoiceId ?? this.invoiceId,
      favorites: favorites ?? this.favorites,
      payment: payment ?? this.payment,
      purchaseContractNumber:
          purchaseContractNumber ?? this.purchaseContractNumber,
      projectName: projectName ?? this.projectName,
      projectCode: projectCode ?? this.projectCode,
      customerName: customerName ?? this.customerName,
      productCategory: productCategory ?? this.productCategory,
      productSelection: productSelection ?? this.productSelection,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      delivery: delivery ?? this.delivery,
      warrantyOfGoods: warrantyOfGoods ?? this.warrantyOfGoods,
      quantity: quantity ?? this.quantity,
      projectDescription: projectDescription ?? this.projectDescription,
      maintenancePeriod: maintenancePeriod ?? this.maintenancePeriod,
      maintenanceCurrency: maintenanceCurrency ?? this.maintenanceCurrency,
      customerContact: customerContact ?? this.customerContact,
      listTeam: listTeam ?? this.listTeam,
    );
  }
}
