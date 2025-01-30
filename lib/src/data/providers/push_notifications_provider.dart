import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/push_notifications_api.dart';

final registerFCMTokenProvider =
    FutureProvider.family<void, ({String userId, String fcmToken})>(
        (ref, params) async {
  final api = ref.watch(pushNotificationsAPIProvider);
  await api.registerFCMToken(params.userId, params.fcmToken);
});
