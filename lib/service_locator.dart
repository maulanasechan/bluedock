import 'package:bluedock/features/home/data/repositories/user_repository_impl.dart';
import 'package:bluedock/features/home/data/sources/user_firebase_service.dart';
import 'package:bluedock/features/home/domain/repositories/user_repository.dart';
import 'package:bluedock/features/home/domain/usecases/get_user_usecase.dart';
import 'package:bluedock/features/home/domain/usecases/logout_usecase.dart';
import 'package:bluedock/features/login/data/repositories/login_repository_impl.dart';
import 'package:bluedock/features/login/data/sources/login_firebase_service.dart';
import 'package:bluedock/features/login/domain/repositories/login_repository.dart';
import 'package:bluedock/features/login/domain/usecases/is_logged_in_usecase.dart';
import 'package:bluedock/features/login/domain/usecases/login_usecase.dart';
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
import 'package:bluedock/features/staff/domain/usecases/update_staff_usecase.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //Services
  sl.registerSingleton<RoleFirebaseService>(RoleFirebaseServiceImpl());
  sl.registerSingleton<StaffFirebaseService>(StaffFirebaseServiceImpl());
  sl.registerSingleton<LoginFirebaseService>(LoginFirebaseServiceImpl());
  sl.registerSingleton<UserFirebaseService>(UserFirebaseServiceImpl());

  //Repositories
  sl.registerSingleton<RoleRepository>(RoleRepositoryImpl());
  sl.registerSingleton<StaffRepository>(StaffRepositoryImpl());
  sl.registerSingleton<LoginRepository>(LoginRepositoryImpl());
  sl.registerSingleton<UserRepository>(UserRepositoryImpl());

  //Role Usecases
  sl.registerSingleton<GetRolesUseCase>(GetRolesUseCase());

  //Staff Usecases
  sl.registerSingleton<AddStaffUseCase>(AddStaffUseCase());
  sl.registerSingleton<GetAllStaffUseCase>(GetAllStaffUseCase());
  sl.registerSingleton<DeleteStaffUsecase>(DeleteStaffUsecase());
  sl.registerSingleton<UpdateStaffUseCase>(UpdateStaffUseCase());

  //Login Usecases
  sl.registerSingleton<LoginUseCase>(LoginUseCase());
  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());

  //User Usecases
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase());
}
