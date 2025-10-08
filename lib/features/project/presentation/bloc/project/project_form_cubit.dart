import 'package:bluedock/features/project/domain/entities/selection/product_selection_entity.dart';
import 'package:bluedock/features/project/domain/entities/selection/category_selection_entity.dart';
import 'package:bluedock/features/project/domain/entities/selection/staff_selection_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluedock/features/project/data/models/project/project_form_req.dart';
import 'package:bluedock/features/project/domain/entities/project_entity.dart';

class ProjectFormCubit extends Cubit<ProjectFormReq> {
  ProjectFormCubit() : super(const ProjectFormReq());

  void setProjectId(String v) => emit(state.copyWith(projectId: v));
  void setPurchaseContractNumber(String v) =>
      emit(state.copyWith(purchaseContractNumber: v));
  void setProjectName(String v) => emit(state.copyWith(projectName: v));
  void setCustomerName(String v) => emit(state.copyWith(customerName: v));
  void setCustomerCompany(String v) => emit(state.copyWith(customerCompany: v));
  void setCustomerContact(String v) => emit(state.copyWith(customerContact: v));
  void setProjectCode(String v) => emit(state.copyWith(projectCode: v));
  void setCurrency(String v) => emit(state.copyWith(currency: v));
  void setPrice(String v) => emit(state.copyWith(price: int.parse(v)));
  void setMaintenancePeriod(String v) =>
      emit(state.copyWith(maintenancePeriod: int.parse(v)));
  void setMaintenanceCurrency(String v) =>
      emit(state.copyWith(maintenanceCurrency: v));

  void setDelivery(String v) => emit(state.copyWith(delivery: v));
  void setPayment(String v) => emit(state.copyWith(payment: v));
  void setWarrantyOfGoods(String v) => emit(state.copyWith(warrantyOfGoods: v));
  void setProjectDescription(String v) =>
      emit(state.copyWith(projectDescription: v));

  void setProductCategory(CategorySelectionEntity v) =>
      emit(state.copyWith(productCategory: v));
  void setProductSelection(ProductSelectionEntity v) =>
      emit(state.copyWith(productSelection: v));

  void setQuantity(int v) => emit(state.copyWith(quantity: v));

  void setQuantityFromText(String v) {
    final parsed = int.tryParse(v) ?? 0;
    emit(state.copyWith(quantity: parsed));
  }

  void toggleTeamByEntity(StaffSelectionEntity m) {
    final exists = state.listTeam.any((e) => e.staffId == m.staffId);

    final updated = exists
        ? state.listTeam.where((e) => e.staffId != m.staffId).toList()
        : [...state.listTeam, m];

    emit(
      state.copyWith(
        listTeam: List<StaffSelectionEntity>.unmodifiable(updated),
      ),
    );
  }

  void hydrateFromEntity(ProjectEntity e) {
    emit(
      ProjectFormReq(
        projectId: e.projectId,
        invoiceId: e.invoiceId,
        purchaseContractNumber: e.purchaseContractNumber,
        projectName: e.projectName,
        projectCode: e.projectCode,
        productCategory: e.productCategory,
        productSelection: e.productSelection,
        price: e.price,
        currency: e.currency,
        delivery: e.delivery,
        warrantyOfGoods: e.warrantyOfGoods,
        quantity: e.quantity,
        projectDescription: e.projectDescription,
        customerCompany: e.customerCompany,
        customerName: e.customerName,
        customerContact: e.customerContact,
        listTeam: e.listTeam,
        payment: e.payment,
        maintenancePeriod: e.maintenancePeriod,
        maintenanceCurrency: e.maintenanceCurrency,
      ),
    );
  }

  // ===== Reset ke nilai awal =====
  void reset() => emit(const ProjectFormReq());
}
