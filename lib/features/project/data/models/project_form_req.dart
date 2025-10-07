import 'package:bluedock/features/project/domain/entities/selection/product_selection_entity.dart';
import 'package:bluedock/features/project/domain/entities/selection/category_selection_entity.dart';

class ProjectFormReq {
  final String projectId;
  final String purchaseContractNumber;
  final String projectName;
  final String projectCode;
  final String customerName;
  final CategorySelectionEntity? productCategory;
  final ProductSelectionEntity? productSelection;
  final int? price;
  final String currency;
  final String payment;
  final String delivery;
  final String warrantyOfGoods;
  final int quantity;
  final String projectDescription;
  final int? maintenancePeriod;
  final String maintenanceCurrency;
  final String customerContact;

  const ProjectFormReq({
    this.projectId = '',
    this.purchaseContractNumber = '',
    this.projectName = '',
    this.projectCode = '',
    this.customerName = '',
    this.productCategory,
    this.productSelection,
    this.price,
    this.currency = 'USD',
    this.payment = '',
    this.delivery = '',
    this.warrantyOfGoods = '',
    this.quantity = 0,
    this.projectDescription = '',
    this.maintenancePeriod,
    this.maintenanceCurrency = 'Month',
    this.customerContact = '',
  });

  ProjectFormReq copyWith({
    String? projectId,
    String? purchaseContractNumber,
    String? projectName,
    String? projectCode,
    String? customerName,
    CategorySelectionEntity? productCategory,
    ProductSelectionEntity? productSelection,
    int? price,
    String? currency,
    String? payment,
    String? delivery,
    String? warrantyOfGoods,
    int? quantity,
    String? projectDescription,
    int? maintenancePeriod,
    String? maintenanceCurrency,
    String? customerContact,
  }) {
    return ProjectFormReq(
      projectId: projectId ?? this.projectId,
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
      payment: payment ?? this.payment,
      quantity: quantity ?? this.quantity,
      warrantyOfGoods: warrantyOfGoods ?? this.warrantyOfGoods,
      projectDescription: projectDescription ?? this.projectDescription,
      maintenancePeriod: maintenancePeriod ?? this.maintenancePeriod,
      maintenanceCurrency: maintenanceCurrency ?? this.maintenanceCurrency,
      customerContact: customerContact ?? this.customerContact,
    );
  }
}
