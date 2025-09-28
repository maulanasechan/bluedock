import 'package:dartz/dartz.dart';

abstract class RoleRepository {
  Future<Either> getRoles();
}
