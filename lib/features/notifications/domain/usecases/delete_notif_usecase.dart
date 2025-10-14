import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/notifications/domain/repositories/notification_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class DeleteNotifUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<NotificationRepository>().deleteNotif(params!);
  }
}
