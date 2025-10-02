import 'package:bluedock/features/home/data/repositories/user_repository_impl.dart';
import 'package:bluedock/features/home/data/sources/user_firebase_service.dart';
import 'package:bluedock/features/home/domain/repositories/user_repository.dart';
import 'package:bluedock/features/home/domain/usecases/get_app_menu_usecase.dart';
import 'package:bluedock/features/home/domain/usecases/get_user_usecase.dart';
import 'package:bluedock/features/home/domain/usecases/logout_usecase.dart';
import 'package:bluedock/features/login/data/repositories/login_repository_impl.dart';
import 'package:bluedock/features/login/data/sources/login_firebase_service.dart';
import 'package:bluedock/features/login/domain/repositories/login_repository.dart';
import 'package:bluedock/features/login/domain/usecases/is_logged_in_usecase.dart';
import 'package:bluedock/features/login/domain/usecases/login_usecase.dart';
import 'package:bluedock/features/login/domain/usecases/send_password_reset_usecase.dart';
import 'package:bluedock/features/product/data/repositories/product_repository_impl.dart';
import 'package:bluedock/features/product/data/repositories/quantum_fresh_water_generator_repository_impl.dart';
import 'package:bluedock/features/product/data/repositories/sperre_air_compressor_repository_impl.dart';
import 'package:bluedock/features/product/data/repositories/sperre_air_system_solutions_repository_impl.dart';
import 'package:bluedock/features/product/data/repositories/sperre_screw_compressor_repository_impl.dart';
import 'package:bluedock/features/product/data/sources/product_firebase_service.dart';
import 'package:bluedock/features/product/data/sources/quantum_fresh_water_generator_firebase_service.dart';
import 'package:bluedock/features/product/data/sources/sperre_air_compressor_firebase_service.dart';
import 'package:bluedock/features/product/data/sources/sperre_air_system_solutions_firebase_service.dart';
import 'package:bluedock/features/product/data/sources/sperre_screw_compressor_firebase_service.dart';
import 'package:bluedock/features/product/domain/repositories/product_repository.dart';
import 'package:bluedock/features/product/domain/repositories/quantum_fresh_water_generator_repository.dart';
import 'package:bluedock/features/product/domain/repositories/sperre_air_compressor_repository.dart';
import 'package:bluedock/features/product/domain/repositories/sperre_air_system_solutions_repository.dart';
import 'package:bluedock/features/product/domain/repositories/sperre_screw_compressor_repository.dart';
import 'package:bluedock/features/product/domain/usecases/product/favorite_product_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/product/get_product_categories_usecase.dart';
import 'package:bluedock/features/product/domain/usecases/product/get_selection_usecase.dart';
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
import 'package:bluedock/features/staff/data/repositories/role_repository_impl.dart';
import 'package:bluedock/features/staff/data/repositories/staff_repository_impl.dart';
import 'package:bluedock/features/staff/data/sources/role_firebase_service.dart';
import 'package:bluedock/features/staff/data/sources/staff_firebase_service.dart';
import 'package:bluedock/features/staff/domain/repositories/role_repository.dart';
import 'package:bluedock/features/staff/domain/repositories/staff_repository.dart';
import 'package:bluedock/features/staff/domain/usecases/add_staff_usecase.dart';
import 'package:bluedock/features/staff/domain/usecases/delete_staff_usecase.dart';
import 'package:bluedock/features/staff/domain/usecases/get_all_staff_usecase.dart';
import 'package:bluedock/features/staff/domain/usecases/get_roles_usecase.dart';
import 'package:bluedock/features/staff/domain/usecases/search_staff_by_name_usecase.dart';
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

  //Role Usecases
  sl.registerSingleton<GetRolesUseCase>(GetRolesUseCase());

  //Staff Usecases
  sl.registerSingleton<AddStaffUseCase>(AddStaffUseCase());
  sl.registerSingleton<GetAllStaffUseCase>(GetAllStaffUseCase());
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

  //Product Usecases
  sl.registerSingleton<GetProductCategoriesUseCase>(
    GetProductCategoriesUseCase(),
  );
  sl.registerSingleton<DeleteProductUseCase>(DeleteProductUseCase());
  sl.registerSingleton<FavoriteProductUseCase>(FavoriteProductUseCase());
  sl.registerSingleton<GetSelectionUseCase>(GetSelectionUseCase());

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
}
