import 'package:bluedock/features/notifications/domain/entities/notification_entity.dart';

abstract class NotifDisplayState {}

class NotifDisplayInitial extends NotifDisplayState {}

class NotifDisplayLoading extends NotifDisplayState {}

class NotifDisplayFetched extends NotifDisplayState {
  final List<NotifEntity> listNotif;
  NotifDisplayFetched({required this.listNotif});
}

class NotifDisplayFailure extends NotifDisplayState {
  final String message;
  NotifDisplayFailure({required this.message});
}
