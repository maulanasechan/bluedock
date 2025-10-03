import 'package:bluedock/features/product/data/models/detegasaIncenerator/detegasa_incenerator_form_req.dart';
import 'package:dartz/dartz.dart';

abstract class DetegasaInceneratorRepository {
  Future<Either> searchDetegasaIncenerator(String query);
  Future<Either> addDetegasaIncenerator(DetegasaInceneratorReq product);
  Future<Either> updateDetegasaIncenerator(DetegasaInceneratorReq product);
}
