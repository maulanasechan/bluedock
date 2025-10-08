import 'package:bluedock/features/project/domain/entities/selection/product_selection_entity.dart';
import 'package:bluedock/features/project/domain/entities/selection/category_selection_entity.dart';
import 'package:bluedock/features/project/domain/entities/selection/staff_selection_entity.dart';

class ProjectFormReq {
  final String projectId;
  final String invoiceId;
  final String purchaseContractNumber;
  final String projectName;
  final String projectCode;
  final String customerName;
  final String customerCompany;
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
  final List<StaffSelectionEntity> listTeam;
  final List<String> favorites;

  const ProjectFormReq({
    this.projectId = '',
    this.invoiceId = '',
    this.purchaseContractNumber = '',
    this.projectName = '',
    this.projectCode = '',
    this.customerName = '',
    this.customerCompany = '',
    this.productCategory,
    this.productSelection,
    this.price,
    this.currency = 'USD',
    this.payment = '',
    this.delivery = '',
    this.warrantyOfGoods = '',
    this.quantity = 1,
    this.projectDescription = '',
    this.maintenancePeriod,
    this.maintenanceCurrency = 'Month',
    this.customerContact = '',
    this.listTeam = const <StaffSelectionEntity>[],
    this.favorites = const <String>[],
  });

  ProjectFormReq copyWith({
    String? projectId,
    String? invoiceId,
    String? purchaseContractNumber,
    String? projectName,
    String? projectCode,
    String? customerName,
    String? customerCompany,
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
    List<StaffSelectionEntity>? listTeam,
    List<String>? favorites,
  }) {
    return ProjectFormReq(
      projectId: projectId ?? this.projectId,
      invoiceId: invoiceId ?? this.invoiceId,
      purchaseContractNumber:
          purchaseContractNumber ?? this.purchaseContractNumber,
      projectName: projectName ?? this.projectName,
      projectCode: projectCode ?? this.projectCode,
      customerName: customerName ?? this.customerName,
      customerCompany: customerCompany ?? this.customerCompany,
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
      listTeam: listTeam ?? this.listTeam,
      favorites: favorites ?? this.favorites,
    );
  }
}
