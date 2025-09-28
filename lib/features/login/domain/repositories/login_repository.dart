import 'package:bluedock/features/login/data/models/login_form_req.dart';
import 'package:dartz/dartz.dart';

abstract class LoginRepository {
  Future<Either> login(LoginFormReq user);
  Future<bool> isLoggedIn();
}
