import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/user_api.dart';
import '../models/user_model.dart';

class UserNotifier extends StateNotifier<AsyncValue<void>> {
  final UserAPI _api;

  UserNotifier(this._api) : super(const AsyncValue.data(null));

  Future<void> updateUser({
    required String userToken,
    required String name,
    String? mobile,
    String? countryCode,
    String? residingCountry,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _api.updateUser(
        userToken: userToken,
        name: name,
        mobile: mobile,
        countryCode: countryCode,
        residingCountry: residingCountry,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<void>>((ref) {
  final api = ref.watch(userAPIProvider);
  return UserNotifier(api);
});

final userDetailsProvider =
    FutureProvider.family<User, String>((ref, token) async {
  final api = ref.watch(userAPIProvider);
  return api.getDetails(token);
});
