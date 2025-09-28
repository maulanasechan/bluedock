import 'package:bluedock/core/config/assets/app_icons.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/home/data/models/app_menu_model.dart';

final List<AppMenuModel> listAppMenu = [
  AppMenuModel(
    appMenuId: '3wtxG3WEvUTX1CAbYUYu',
    title: "Project",
    icon: AppIcons.iconProject,
    route: AppRoutes.underConstruction,
  ),
  AppMenuModel(
    appMenuId: 'H7kLp3wqZx81vFRtB2Ns',
    title: "Inventory",
    icon: AppIcons.iconInventory,
    route: AppRoutes.underConstruction,
  ),
  AppMenuModel(
    appMenuId: 'gU92hXLqT4mbP5sYc7Vn',
    title: "Aftersales",
    icon: AppIcons.iconAftersales,
    route: AppRoutes.underConstruction,
  ),
  AppMenuModel(
    appMenuId: 'DqR1f8yZW3jT6nKb9xMo',
    title: "Products",
    icon: AppIcons.iconProducts,
    route: AppRoutes.underConstruction,
  ),
  AppMenuModel(
    appMenuId: 'Z7uJp6kR2tYxL9mWv3Ha',
    title: "Purchase Order",
    icon: AppIcons.iconPurchaseOrder,
    route: AppRoutes.underConstruction,
  ),
  AppMenuModel(
    appMenuId: 'a4QxN1mZr7VyH3fGp8Tu',
    title: "Finance",
    icon: AppIcons.iconFinance,
    route: AppRoutes.accessDenied,
  ),
  AppMenuModel(
    appMenuId: 'tX5jR8nYw2pL7zM9qVkB',
    title: "Receipt",
    icon: AppIcons.iconReceipt,
    route: AppRoutes.youAreOffline,
  ),
  AppMenuModel(
    appMenuId: 'b6UqK3yZn1HrT4xP9wVm',
    title: "Delivery Order",
    icon: AppIcons.iconDeliveryOrder,
    route: AppRoutes.underConstruction,
  ),
  AppMenuModel(
    appMenuId: 'Jm7hW2tQp8zX5vL4kRc9',
    title: "Manage Staff",
    icon: AppIcons.iconStaff,
    route: AppRoutes.manageStaff,
  ),
  AppMenuModel(
    appMenuId: 'f9TzL3rM6nW1pX8vQkYa',
    title: "Daily Task",
    icon: AppIcons.iconDailyTask,
    route: AppRoutes.pageNotFound,
  ),
];
