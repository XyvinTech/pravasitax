import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/customer_api.dart';
import '../models/customer_model.dart';

class CustomerNotifier extends StateNotifier<AsyncValue<void>> {
  final CustomerAPI _api;

  CustomerNotifier(this._api) : super(const AsyncValue.data(null));

  Future<void> updateCustomer({
    required String userToken,
    required String name,
    String? mobile,
    String? countryCode,
    String? residingCountry,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _api.updateCustomer(
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

final customerProvider =
    StateNotifierProvider<CustomerNotifier, AsyncValue<void>>((ref) {
  final api = ref.watch(customerAPIProvider);
  return CustomerNotifier(api);
});

final customerDetailsProvider =
    FutureProvider.family<Customer, String>((ref, token) async {
  final api = ref.watch(customerAPIProvider);
  return api.getDetails(token);
});
