import 'package:bluedock/common/data/models/role/role_model.dart';
import 'package:bluedock/features/staff/data/sources/role_firebase_service.dart';
import 'package:bluedock/features/staff/domain/repositories/role_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class RoleRepositoryImpl extends RoleRepository {
  @override
  Future<Either> getRoles() async {
    var listRole = await sl<RoleFirebaseService>().getRoles();
    return listRole.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data).map((e) => RoleModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }
}
