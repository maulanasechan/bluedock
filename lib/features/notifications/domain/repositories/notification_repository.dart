import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:dartz/dartz.dart';

abstract class NotificationRepository {
  Future<Either> searchNotif(SearchWithTypeReq req);
  Future<Either> deleteNotif(String notifId);
  Future<Either> countUnread();
  Future<Either> readNotif(String notifId);
}
