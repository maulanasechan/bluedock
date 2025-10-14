import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/features/notifications/data/models/notification_model.dart';
import 'package:bluedock/features/notifications/data/sources/notification_firebase_service.dart';
import 'package:bluedock/features/notifications/domain/repositories/notification_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  @override
  Future<Either> searchNotif(SearchWithTypeReq query) async {
    final res = await sl<NotificationFirebaseService>().searchNotif(query);
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(data).map((e) => NotifModel.fromMap(e).toEntity()).toList(),
      ),
    );
  }

  @override
  Future<Either> deleteNotif(String notifId) async {
    return await sl<NotificationFirebaseService>().deleteNotif(notifId);
  }

  @override
  Future<Either> readNotif(String notifId) async {
    return await sl<NotificationFirebaseService>().readNotif(notifId);
  }

  @override
  Future<Either> countUnread() async {
    return await sl<NotificationFirebaseService>().countUnread();
  }
}
