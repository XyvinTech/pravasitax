import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/events_api.dart';
import '../models/event_model.dart';

final eventsProvider = FutureProvider<List<Event>>((ref) async {
  final api = ref.watch(eventsAPIProvider);
  return api.getEvents();
});

final eventBookingProvider =
    FutureProvider.family<String?, ({String eventId, int seats})>(
        (ref, params) async {
  final api = ref.watch(eventsAPIProvider);
  return api.bookEvent(params.eventId, params.seats);
});
