import 'package:bluedock/common/domain/entities/staff_entity.dart';
import 'package:bluedock/features/home/data/models/app_menu_model.dart';
import 'package:bluedock/features/home/data/models/change_password_req.dart';
import 'package:bluedock/features/home/data/sources/user_firebase_service.dart';
import 'package:bluedock/features/home/domain/repositories/user_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class UserRepositoryImpl extends UserRepository {
  @override
  Future<Either> logout() async {
    return await sl<UserFirebaseService>().logout();
  }

  @override
  Future<Either> changePassword(ChangePasswordReq password) async {
    return await sl<UserFirebaseService>().changePassword(
      oldPassword: password.oldPassword,
      newPassword: password.newPassword,
    );
  }

  @override
  Future<Either> getAppMenu(StaffEntity user) async {
    var returnedData = await sl<UserFirebaseService>().getAppMenu(user);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => AppMenuModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }
}
