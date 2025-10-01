import 'package:bluedock/features/login/data/models/login_form_req.dart';
import 'package:bluedock/features/login/data/sources/login_firebase_service.dart';
import 'package:bluedock/features/login/domain/repositories/login_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class LoginRepositoryImpl extends LoginRepository {
  @override
  Future<Either> login(LoginFormReq user) async {
    return await sl<LoginFirebaseService>().login(user);
  }

  @override
  Future<bool> isLoggedIn() async {
    return await sl<LoginFirebaseService>().isLoggedIn();
  }

  @override
  Future<Either> sendPasswordReset(String email) async {
    return await sl<LoginFirebaseService>().sendPasswordReset(email);
  }
}
