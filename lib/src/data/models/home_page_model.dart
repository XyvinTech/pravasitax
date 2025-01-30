import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_model.freezed.dart';
part 'home_page_model.g.dart';

@freezed
class HomePageData with _$HomePageData {
  const factory HomePageData({
    required List<Service> serviceList,
    required List<Scenario> scenarios,
    required List<Banner> firstSectionBanners,
    required List<TaxTool> taxTools,
    Event? event,
    required List<Blog> blogs,
  }) = _HomePageData;

  factory HomePageData.fromJson(Map<String, dynamic> json) =>
      _$HomePageDataFromJson(json);
}

@freezed
class Service with _$Service {
  const factory Service({
    required String service,
    String? url,
    String? image,
  }) = _Service;

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);
}

@freezed
class Scenario with _$Scenario {
  const factory Scenario({
    required String scenario,
    String? url,
  }) = _Scenario;

  factory Scenario.fromJson(Map<String, dynamic> json) =>
      _$ScenarioFromJson(json);
}

@freezed
class Banner with _$Banner {
  const factory Banner({
    required String title,
    required String label,
    String? url,
    required String image,
    String? button,
  }) = _Banner;

  factory Banner.fromJson(Map<String, dynamic> json) => _$BannerFromJson(json);
}

@freezed
class TaxTool with _$TaxTool {
  const factory TaxTool({
    required String title,
    String? url,
    String? image,
  }) = _TaxTool;

  factory TaxTool.fromJson(Map<String, dynamic> json) =>
      _$TaxToolFromJson(json);
}

@freezed
class Event with _$Event {
  const factory Event({
    required String title,
    String? type,
    required String banner,
    required String date,
    required String time,
    required String location,
    String? price,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

@freezed
class Blog with _$Blog {
  const factory Blog({
    required String id,
    required String title,
    String? url,
    @JsonKey(name: 'short_description') String? shortDescription,
    String? author,
    @JsonKey(name: 'posted_date') DateTime? postedDate,
    List<String>? tags,
    String? thumbnail,
    String? category,
    @JsonKey(name: 'sub_category') String? subCategory,
    @JsonKey(name: 'status_text') String? statusText,
  }) = _Blog;

  factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);
}
