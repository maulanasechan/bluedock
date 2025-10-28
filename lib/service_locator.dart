import 'package:bluedock/common/data/repositories/item_selection_repository_impl.dart';
import 'package:bluedock/common/data/repositories/product_section_repository_impl.dart';
import 'package:bluedock/common/data/repositories/project_section_repository_impl.dart';
import 'package:bluedock/common/data/sources/item_selection_firebase_service.dart';
import 'package:bluedock/common/data/sources/product_section_firebase_service.dart';
import 'package:bluedock/common/data/sources/project_section_firebase_service.dart';
import 'package:bluedock/common/domain/repositories/item_selection_repository.dart';
import 'package:bluedock/common/domain/repositories/product_section_repository.dart';
import 'package:bluedock/common/domain/repositories/project_section_repository.dart';
import 'package:bluedock/common/domain/usecases/get_product_selection_usecase.dart';
import 'package:bluedock/common/domain/usecases/get_project_by_id_usecase.dart';
import 'package:bluedock/common/domain/usecases/get_type_category_selection_usecase.dart';
import 'package:bluedock/features/dailyTask/data/repositories/daily_task_repository_impl.dart';
import 'package:bluedock/features/dailyTask/data/sources/daily_task_firebase_service.dart';
import 'package:bluedock/features/dailyTask/domain/repositories/daily_task_repository.dart';
import 'package:bluedock/features/dailyTask/domain/usecases/add_daily_task_usecase.dart';
import 'package:bluedock/features/dailyTask/domain/usecases/delete_daily_task_usecase.dart';
import 'package:bluedock/features/dailyTask/domain/usecases/get_all_daily_task_usecase.dart';
import 'package:bluedock/features/dailyTask/domain/usecases/get_daily_task_by_id_usecase.dart';
import 'package:bluedock/features/dailyTask/domain/usecases/update_detegasa_incenerator_usecase.dart';
import 'package:bluedock/features/home/data/repositories/user_repository_impl.dart';
import 'package:bluedock/features/home/data/sources/user_firebase_service.dart';
import 'package:bluedock/features/home/domain/repositories/user_repository.dart';
import 'package:bluedock/features/home/domain/usecases/get_app_menu_usecase.dart';
import 'package:bluedock/common/domain/usecases/get_user_usecase.dart';
import 'package:bluedock/features/home/domain/usecases/logout_usecase.dart';
import 'package:bluedock/features/inventories/data/repositories/inventory_repository_impl.dart';
import 'package:bluedock/features/inventories/data/sources/inventory_firebase_service.dart';
import 'package:bluedock/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:bluedock/features/inventories/domain/usecases/add_inventory_usecase.dart';
import 'package:bluedock/features/inventories/domain/usecases/delete_inventory_usecase.dart';
import 'package:bluedock/features/inventories/domain/usecases/favorite_inventory_usecase.dart';
import 'package:bluedock/features/inventories/domain/usecases/get_inventory_by_id_usecase.dart';
import 'package:bluedock/features/inventories/domain/usecases/search_inventory_usecase.dart';
import 'package:bluedock/features/inventories/domain/usecases/update_inventory_usecase.dart';
import 'package:bluedock/features/invoice/data/repositories/invoice_repository_impl.dart';
import 'package:bluedock/features/invoice/data/sources/invoice_firebase_service.dart';
import 'package:bluedock/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:bluedock/features/invoice/domain/usecases/favorite_invoice_usecase.dart';
import 'package:bluedock/features/invoice/domain/usecases/get_invoice_by_id_usecase.dart';
import 'package:bluedock/features/invoice/domain/usecases/paid_invoice_usecase.dart';
import 'package:bluedock/features/invoice/domain/usecases/search_invoice_usecase.dart';
import 'package:bluedock/features/login/data/repositories/login_repository_impl.dart';
import 'package:bluedock/features/login/data/sources/login_firebase_service.dart';
import 'package:bluedock/features/login/domain/repositories/login_repository.dart';
import 'package:bluedock/features/login/domain/usecases/is_logged_in_usecase.dart';
import 'package:bluedock/features/login/domain/usecases/login_usecase.dart';
import 'package:bluedock/features/login/domain/usecases/send_password_reset_usecase.dart';
import 'package:bluedock/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:bluedock/features/notifications/data/sources/notification_firebase_service.dart';
import 'package:bluedock/features/notifications/domain/repositories/notification_repository.dart';
import 'package:bluedock/features/notifications/domain/usecases/count_unread_usecase.dart';
import 'package:bluedock/features/notifications/domain/usecases/delete_notif_usecase.dart';
import 'package:bluedock/features/notifications/domain/usecases/read_notif_usecase.dart';
import 'package:bluedock/features/notifications/domain/usecases/search_notif_usecase.dart';
import 'package:bluedock/features/product/data/repositories/detegasa_incenerator_repository_impl.dart';
import 'package:bluedock/features/product/data/repositories/detegasa_oily_water_separator_impl.dart';
import 'package:bluedock/features/product/data/repositories/detegasa_sewage_treatment_plant_repository_impl.dart';
import 'package:bluedock/features/product/data/repositories/product_repository_impl.dart';
import 'package:bluedock/features/product/data/repositories/quantum_fresh_water_generator_repository_impl.dart';
import 'package:bluedock/features/product/data/repositories/sperre_air_compressor_repository_impl.dart';
import 'package:bluedock/features/product/data/repositories/sperre_air_system_solutions_repository_impl.dart';
import 'package:bluedock/features/product/data/repositories/sperre_screw_compressor_repository_impl.dart';
import 'package:bluedock/features/product/data/sources/detegasa_incenerator_firebase_service.dart';
import 'package:bluedock/features/product/data/sources/detegasa_oily_water_separator_firebase_service.dart';
import 'package:bluedock/features/product/data/sources/detegasa_sewage_treatment_plant_firebase_service.dart';
import 'package:bluedock/features/product/data/sources/product_firebase_service.dart';
import 'package:bluedock/features/product/data/sources/quantum_fresh_water_generator_firebase_service.dart';
import 'package:bluedock/features/product/data/sources/sperre_air_compressor_firebase_service.dart';
import 'package:bluedock/features/product/data/sources/sperre_air_system_solutions_firebase_service.dart';
import 'package:bluedock/features/product/data/sources/sperre_screw_compressor_firebase_service.dart';
import 'package:bluedock/features/product/domain/repositories/detegasa_incenerator_repository.dart';
import 'package:bluedock/features/product/domain/repositories/detegasa_oily_water_separator_repository.dart';
import 'package:bluedock/features/product/domain/repositories/detegasa_sewage_treatment_plant_repository.dart';
import 'package:bluedock/features/product/domain/repositories/product_repository.dart';
import 'package:bluedock/features/product/domain/repositories/quantum_fresh_water_generator_repository.dart';
import 'package:bluedock/features/product/domain/repositories/sperre_air_compressor_repository.dart';
import 'package:bluedock/features/product/domain/repositories/sperre_air_system_solutions_repository.dart';
import 'package:bluedock/features/product/domain/repositories/sperre_screw_compressor_repository.dart';
import 'package:bluedock/features/product/domain/usecases/detegasaIncenerator/add_detegasa_incenerator_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/detegasaIncenerator/search_detegasa_incenerator_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/detegasaIncenerator/update_detegasa_incenerator_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/detegasaOilyWaterSeparator/add_detegasa_oily_water_separator_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/detegasaOilyWaterSeparator/search_detegasa_oily_water_separator_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/detegasaOilyWaterSeparator/update_detegasa_oily_water_separator_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/detegasaSewageTreatmentPlant/add_detegasa_sewage_treatment_plant_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/detegasaSewageTreatmentPlant/search_detegasa_sewage_treatment_plant_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/detegasaSewageTreatmentPlant/update_detegasa_sewage_treatment_plant_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/product/favorite_product_usecase.dart';
import 'package:bluedock/common/domain/usecases/get_product_categories_usecase.dart';
import 'package:bluedock/common/domain/usecases/get_item_selection_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/quantumFreshWaterGenerator/add_quantum_fresh_water_generator_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/quantumFreshWaterGenerator/search_quantum_fresh_water_generator_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/quantumFreshWaterGenerator/update_quantum_fresh_water_generator_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/sperreAirCompressor/add_sperre_air_compressor_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/product/delete_product_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/sperreAirCompressor/search_sperre_air_compressor_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/sperreAirCompressor/update_sperre_air_compressor_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/sperreAirSystemSolutions/add_sperre_air_system_solutions_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/sperreAirSystemSolutions/search_sperre_air_system_solutions_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/sperreAirSystemSolutions/update_sperre_air_system_solutions_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/sperreScrewCompressor/add_sperre_screw_compressor_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/sperreScrewCompressor/search_sperre_screw_compressor_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/sperreScrewCompressor/update_sperre_screw_compressor_usecase.dart';
import 'package:bluedock/features/project/data/repositories/project_repository_impl.dart';
import 'package:bluedock/features/project/data/sources/project_firebase_service.dart';
import 'package:bluedock/features/project/domain/repositories/project_repository.dart';
import 'package:bluedock/features/project/domain/usecases/add_project_usecase.dart';
import 'package:bluedock/features/project/domain/usecases/commision_project_usecase.dart';
import 'package:bluedock/features/project/domain/usecases/delete_project_usecase.dart';
import 'package:bluedock/features/project/domain/usecases/favorite_project_usecase.dart';
import 'package:bluedock/common/domain/usecases/search_project_usecase.dart';
import 'package:bluedock/features/purchaseOrders/data/repositories/purchase_order_repository_impl.dart';
import 'package:bluedock/features/purchaseOrders/data/sources/purchase_order_firebase_service.dart';
import 'package:bluedock/features/purchaseOrders/domain/repositories/purchase_order_repository.dart';
import 'package:bluedock/features/purchaseOrders/domain/usecases/add_purchase_order_usecase.dart';
import 'package:bluedock/features/purchaseOrders/domain/usecases/delete_purchase_order_usecase.dart';
import 'package:bluedock/features/purchaseOrders/domain/usecases/get_purchase_order_by_id_usecase.dart';
import 'package:bluedock/features/purchaseOrders/domain/usecases/search_purchase_order_usecase.dart';
import 'package:bluedock/features/purchaseOrders/domain/usecases/update_purchase_order_usecase.dart';
import 'package:bluedock/features/staff/data/repositories/role_repository_impl.dart';
import 'package:bluedock/common/data/repositories/staff_repository_impl.dart';
import 'package:bluedock/features/staff/data/sources/role_firebase_service.dart';
import 'package:bluedock/common/data/sources/staff_firebase_service.dart';
import 'package:bluedock/features/staff/domain/repositories/role_repository.dart';
import 'package:bluedock/common/domain/repositories/staff_repository.dart';
import 'package:bluedock/features/staff/domain/usecases/add_staff_usecase.dart';
import 'package:bluedock/features/staff/domain/usecases/delete_staff_usecase.dart';
import 'package:bluedock/features/staff/domain/usecases/get_roles_usecase.dart';
import 'package:bluedock/common/domain/usecases/search_staff_by_name_usecase.dart';
import 'package:bluedock/features/staff/domain/usecases/update_staff_usecase.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //Services
  sl.registerSingleton<RoleFirebaseService>(RoleFirebaseServiceImpl());
  sl.registerSingleton<StaffFirebaseService>(StaffFirebaseServiceImpl());
  sl.registerSingleton<LoginFirebaseService>(LoginFirebaseServiceImpl());
  sl.registerSingleton<UserFirebaseService>(UserFirebaseServiceImpl());
  sl.registerSingleton<ProductFirebaseService>(ProductFirebaseServiceImpl());
  sl.registerSingleton<SperreAirCompressorFirebaseService>(
    SperreAirCompressorFirebaseServiceImpl(),
  );
  sl.registerSingleton<SperreScrewCompressorFirebaseService>(
    SperreScrewCompressorFirebaseServiceImpl(),
  );
  sl.registerSingleton<SperreAirSystemSolutionsFirebaseService>(
    SperreAirSystemSolutionsFirebaseServiceImpl(),
  );
  sl.registerSingleton<QuantumFreshWaterGeneratorFirebaseService>(
    QuantumFreshWaterGeneratorFirebaseServiceImpl(),
  );
  sl.registerSingleton<DetegasaSewageTreatmentPlantFirebaseService>(
    DetegasaSewageTreatmentPlantFirebaseServiceImpl(),
  );
  sl.registerSingleton<DetegasaInceneratorFirebaseService>(
    DetegasaInceneratorFirebaseServiceImpl(),
  );
  sl.registerSingleton<DetegasaOilyWaterSeparatorFirebaseService>(
    DetegasaOilyWaterSeparatorFirebaseServiceImpl(),
  );
  sl.registerSingleton<ProjectFirebaseService>(ProjectFirebaseServiceImpl());
  sl.registerSingleton<ProductSectionFirebaseService>(
    ProductSectionFirebaseServiceImpl(),
  );
  sl.registerSingleton<ItemSelectionFirebaseService>(
    ItemSelectionFirebaseServiceImpl(),
  );
  sl.registerSingleton<DailyTaskFirebaseService>(
    DailyTaskFirebaseServiceImpl(),
  );
  sl.registerSingleton<ProjectSectionFirebaseService>(
    ProjectSectionFirebaseServiceImpl(),
  );
  sl.registerSingleton<InvoiceFirebaseService>(InvoiceFirebaseServiceImpl());
  sl.registerSingleton<NotificationFirebaseService>(
    NotificationFirebaseServiceImpl(),
  );
  sl.registerSingleton<PurchaseOrderFirebaseService>(
    PurchaseOrderFirebaseServiceImpl(),
  );
  sl.registerSingleton<InventoryFirebaseService>(
    InventoryFirebaseServiceImpl(),
  );

  //Repositories
  sl.registerSingleton<RoleRepository>(RoleRepositoryImpl());
  sl.registerSingleton<StaffRepository>(StaffRepositoryImpl());
  sl.registerSingleton<LoginRepository>(LoginRepositoryImpl());
  sl.registerSingleton<UserRepository>(UserRepositoryImpl());
  sl.registerSingleton<ProductRepository>(ProductRepositoryImpl());
  sl.registerSingleton<SperreAirCompressorRepository>(
    SperreAirCompressorRepositoryImpl(),
  );
  sl.registerSingleton<SperreScrewCompressorRepository>(
    SperreSrewCompressorRepositoryImpl(),
  );
  sl.registerSingleton<SperreAirSystemSolutionsRepository>(
    SperreAirSystemSolutionsRepositoryImpl(),
  );
  sl.registerSingleton<QuantumFreshWaterGeneratorRepository>(
    QuantumFreshWaterGeneratorRepositoryImpl(),
  );
  sl.registerSingleton<DetegasaSewageTreatmentPlantRepository>(
    DetegasaSewageTreatmentPlantRepositoryImpl(),
  );
  sl.registerSingleton<DetegasaInceneratorRepository>(
    DetegasaInceneratorRepositoryImpl(),
  );
  sl.registerSingleton<DetegasaOilyWaterSeparatorRepository>(
    DetegasaOilyWaterSeparatorRepositoryImpl(),
  );
  sl.registerSingleton<ProjectRepository>(ProjectRepositoryImpl());
  sl.registerSingleton<ProjectSectionRepository>(
    ProjectSectionRepositoryImpl(),
  );
  sl.registerSingleton<ProductSectionRepository>(
    ProductSectionRepositoryImpl(),
  );
  sl.registerSingleton<ItemSelectionRepository>(ItemSelectionRepositoryImpl());
  sl.registerSingleton<DailyTaskRepository>(DailyTaskRepositoryImpl());
  sl.registerSingleton<InvoiceRepository>(InvoiceRepositoryImpl());
  sl.registerSingleton<NotificationRepository>(NotificationRepositoryImpl());
  sl.registerSingleton<PurchaseOrderRepository>(PurchaseOrderRepositoryImpl());
  sl.registerSingleton<InventoryRepository>(InventoryRepositoryImpl());

  //Inventory Usecases
  sl.registerSingleton<SearchInventoryUseCase>(SearchInventoryUseCase());
  sl.registerSingleton<GetInventoryByIdUseCase>(GetInventoryByIdUseCase());
  sl.registerSingleton<AddInventoryUseCase>(AddInventoryUseCase());
  sl.registerSingleton<UpdateInventoryUseCase>(UpdateInventoryUseCase());
  sl.registerSingleton<DeleteInventoryUseCase>(DeleteInventoryUseCase());
  sl.registerSingleton<FavoriteInventoryUseCase>(FavoriteInventoryUseCase());

  //Notification Usecases
  sl.registerSingleton<SearchPurchaseOrderUseCase>(
    SearchPurchaseOrderUseCase(),
  );
  sl.registerSingleton<GetPurchaseOrderByIdUseCase>(
    GetPurchaseOrderByIdUseCase(),
  );
  sl.registerSingleton<UpdatePurchaseOrderUseCase>(
    UpdatePurchaseOrderUseCase(),
  );
  sl.registerSingleton<DeletePurchaseOrderUseCase>(
    DeletePurchaseOrderUseCase(),
  );
  sl.registerSingleton<AddPurchaseOrderUseCase>(AddPurchaseOrderUseCase());

  //Notification Usecases
  sl.registerSingleton<SearchNotifUseCase>(SearchNotifUseCase());
  sl.registerSingleton<DeleteNotifUseCase>(DeleteNotifUseCase());
  sl.registerSingleton<CountUnreadUseCase>(CountUnreadUseCase());
  sl.registerSingleton<ReadNotifUseCase>(ReadNotifUseCase());

  //Invoice Usecases
  sl.registerSingleton<SearchInvoiceUseCase>(SearchInvoiceUseCase());
  sl.registerSingleton<GetInvoiceByIdUseCase>(GetInvoiceByIdUseCase());
  sl.registerSingleton<PaidInvoiceUseCase>(PaidInvoiceUseCase());
  sl.registerSingleton<FavoriteInvoiceUseCase>(FavoriteInvoiceUseCase());

  //Role Usecases
  sl.registerSingleton<GetRolesUseCase>(GetRolesUseCase());

  //Staff Usecases
  sl.registerSingleton<AddStaffUseCase>(AddStaffUseCase());
  sl.registerSingleton<DeleteStaffUseCase>(DeleteStaffUseCase());
  sl.registerSingleton<UpdateStaffUseCase>(UpdateStaffUseCase());
  sl.registerSingleton<SearchStaffByNameUseCase>(SearchStaffByNameUseCase());

  //Login Usecases
  sl.registerSingleton<LoginUseCase>(LoginUseCase());
  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());
  sl.registerSingleton<SendPasswordResetUseCase>(SendPasswordResetUseCase());

  //User Usecases
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase());
  sl.registerSingleton<GetAppMenuUseCase>(GetAppMenuUseCase());

  //Product Categories Usecases
  sl.registerSingleton<GetProductCategoriesUseCase>(
    GetProductCategoriesUseCase(),
  );

  //Daily Task Usecases
  sl.registerSingleton<GetAllDailyTaskUseCase>(GetAllDailyTaskUseCase());
  sl.registerSingleton<UpdateDailyTaskUseCase>(UpdateDailyTaskUseCase());
  sl.registerSingleton<AddDailyTaskUseCase>(AddDailyTaskUseCase());
  sl.registerSingleton<DeleteDailyTaskUseCase>(DeleteDailyTaskUseCase());
  sl.registerSingleton<GetDailyTaskByIdUseCase>(GetDailyTaskByIdUseCase());

  //Product Selection Usecases
  sl.registerSingleton<GetProductSelectionUseCase>(
    GetProductSelectionUseCase(),
  );

  //Item Selection Usecases
  sl.registerSingleton<GetItemSelectionUseCase>(GetItemSelectionUseCase());
  sl.registerSingleton<GetTypeCategorySelectionUseCase>(
    GetTypeCategorySelectionUseCase(),
  );

  //Product Usecases
  sl.registerSingleton<DeleteProductUseCase>(DeleteProductUseCase());
  sl.registerSingleton<FavoriteProductUseCase>(FavoriteProductUseCase());

  // Sperre Air Compressor
  sl.registerSingleton<SearchSperreAirCompressorUseCase>(
    SearchSperreAirCompressorUseCase(),
  );
  sl.registerSingleton<AddSperreAirCompressorUseCase>(
    AddSperreAirCompressorUseCase(),
  );
  sl.registerSingleton<UpdateSperreAirCompressorUseCase>(
    UpdateSperreAirCompressorUseCase(),
  );

  // Sperre Air System Solutions
  sl.registerSingleton<SearchSperreAirSystemSolutionsUseCase>(
    SearchSperreAirSystemSolutionsUseCase(),
  );
  sl.registerSingleton<AddSperreAirSystemSolutionsUseCase>(
    AddSperreAirSystemSolutionsUseCase(),
  );
  sl.registerSingleton<UpdateSperreAirSystemSolutionsUseCase>(
    UpdateSperreAirSystemSolutionsUseCase(),
  );

  // Sperre Screw Compressor Solutions
  sl.registerSingleton<SearchSperreScrewCompressorUseCase>(
    SearchSperreScrewCompressorUseCase(),
  );
  sl.registerSingleton<AddSperreScrewCompressorUseCase>(
    AddSperreScrewCompressorUseCase(),
  );
  sl.registerSingleton<UpdateSperreScrewCompressorUseCase>(
    UpdateSperreScrewCompressorUseCase(),
  );

  // Quantum Fresh Water Generator
  sl.registerSingleton<SearchQuantumFreshWaterGeneratorUseCase>(
    SearchQuantumFreshWaterGeneratorUseCase(),
  );
  sl.registerSingleton<AddQuantumFreshWaterGeneratorUseCase>(
    AddQuantumFreshWaterGeneratorUseCase(),
  );
  sl.registerSingleton<UpdateQuantumFreshWaterGeneratorUseCase>(
    UpdateQuantumFreshWaterGeneratorUseCase(),
  );

  // Detegasa Sewage Treatment Plant
  sl.registerSingleton<SearchDetegasaSewageTreatmentPlantUseCase>(
    SearchDetegasaSewageTreatmentPlantUseCase(),
  );
  sl.registerSingleton<AddDetegasaSewageTreatmentPlantUseCase>(
    AddDetegasaSewageTreatmentPlantUseCase(),
  );
  sl.registerSingleton<UpdateDetegasaSewageTreatmentPlantUseCase>(
    UpdateDetegasaSewageTreatmentPlantUseCase(),
  );

  // Detegasa Incenerator
  sl.registerSingleton<SearchDetegasaInceneratorUseCase>(
    SearchDetegasaInceneratorUseCase(),
  );
  sl.registerSingleton<AddDetegasaInceneratorUseCase>(
    AddDetegasaInceneratorUseCase(),
  );
  sl.registerSingleton<UpdateDetegasaInceneratorUseCase>(
    UpdateDetegasaInceneratorUseCase(),
  );

  // Detegasa Oily Water Separator
  sl.registerSingleton<SearchDetegasaOilyWaterSeparatorUseCase>(
    SearchDetegasaOilyWaterSeparatorUseCase(),
  );
  sl.registerSingleton<AddDetegasaOilyWaterSeparatorUseCase>(
    AddDetegasaOilyWaterSeparatorUseCase(),
  );
  sl.registerSingleton<UpdateDetegasaOilyWaterSeparatorUseCase>(
    UpdateDetegasaOilyWaterSeparatorUseCase(),
  );

  // Project
  sl.registerSingleton<AddProjectUseCase>(AddProjectUseCase());
  sl.registerSingleton<SearchProjectUseCase>(SearchProjectUseCase());
  sl.registerSingleton<GetProjectByIdUseCase>(GetProjectByIdUseCase());
  sl.registerSingleton<DeleteProjectUseCase>(DeleteProjectUseCase());
  sl.registerSingleton<FavoriteProjectUseCase>(FavoriteProjectUseCase());
  sl.registerSingleton<CommisionProjectUseCase>(CommisionProjectUseCase());
}
