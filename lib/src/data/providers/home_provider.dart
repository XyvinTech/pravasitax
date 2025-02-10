import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravasitax_flutter/src/data/services/secure_storage_service.dart';
import '../api/home_api.dart';
import '../models/home_page_model.dart';

class HomeState {
  final bool isLoading;
  final String? error;
  final HomePageData? data;

  HomeState({
    this.isLoading = false,
    this.error,
    this.data,
  });

  HomeState copyWith({
    bool? isLoading,
    String? error,
    HomePageData? data,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      data: data ?? this.data,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final HomeAPI _homeAPI;

  HomeNotifier(this._homeAPI) : super(HomeState());

  Future<void> fetchHomePageData() async {
    state = state.copyWith(isLoading: true, error: null);
        final token = await SecureStorageService.getAuthToken();

    try {
      final data = await _homeAPI.getHomePageData(token??'');
      state = state.copyWith(isLoading: false, data: data);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(ref.watch(homeAPIProvider));
}); 