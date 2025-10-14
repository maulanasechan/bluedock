import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/notifications/domain/repositories/notification_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class SearchNotifUseCase implements UseCase<Either, SearchWithTypeReq> {
  @override
  Future<Either> call({SearchWithTypeReq? params}) async {
    return await sl<NotificationRepository>().searchNotif(params!);
  }
}
