import 'package:bluedock/core/config/assets/app_icons.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/home/data/models/menu_model.dart';

final List<MenuModel> listMenu = [
  MenuModel(
    title: "Project",
    icon: AppIcons.iconProject,
    route: AppRoutes.underConstruction,
  ),
  MenuModel(
    title: "Inventory",
    icon: AppIcons.iconInventory,
    route: AppRoutes.underConstruction,
  ),
  MenuModel(
    title: "Aftersales",
    icon: AppIcons.iconAftersales,
    route: AppRoutes.underConstruction,
  ),
  MenuModel(
    title: "Products",
    icon: AppIcons.iconProducts,
    route: AppRoutes.underConstruction,
  ),
  MenuModel(
    title: "Purchase Order",
    icon: AppIcons.iconPurchaseOrder,
    route: AppRoutes.underConstruction,
  ),
  MenuModel(
    title: "Finance",
    icon: AppIcons.iconFinance,
    route: AppRoutes.accessDenied,
  ),
  MenuModel(
    title: "Receipt",
    icon: AppIcons.iconReceipt,
    route: AppRoutes.youAreOffline,
  ),
  MenuModel(
    title: "Delivery Order",
    icon: AppIcons.iconDeliveryOrder,
    route: AppRoutes.underConstruction,
  ),
  MenuModel(
    title: "Manage Staff",
    icon: AppIcons.iconStaff,
    route: AppRoutes.manageStaff,
  ),
  MenuModel(
    title: "Daily Task",
    icon: AppIcons.iconDailyTask,
    route: AppRoutes.pageNotFound,
  ),
];
