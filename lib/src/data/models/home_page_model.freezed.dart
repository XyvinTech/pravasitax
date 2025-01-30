// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HomePageData _$HomePageDataFromJson(Map<String, dynamic> json) {
  return _HomePageData.fromJson(json);
}

/// @nodoc
mixin _$HomePageData {
  List<Service> get serviceList => throw _privateConstructorUsedError;
  List<Scenario> get scenarios => throw _privateConstructorUsedError;
  List<Banner> get firstSectionBanners => throw _privateConstructorUsedError;
  List<TaxTool> get taxTools => throw _privateConstructorUsedError;
  Event? get event => throw _privateConstructorUsedError;
  List<Blog> get blogs => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HomePageDataCopyWith<HomePageData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomePageDataCopyWith<$Res> {
  factory $HomePageDataCopyWith(
          HomePageData value, $Res Function(HomePageData) then) =
      _$HomePageDataCopyWithImpl<$Res, HomePageData>;
  @useResult
  $Res call(
      {List<Service> serviceList,
      List<Scenario> scenarios,
      List<Banner> firstSectionBanners,
      List<TaxTool> taxTools,
      Event? event,
      List<Blog> blogs});

  $EventCopyWith<$Res>? get event;
}

/// @nodoc
class _$HomePageDataCopyWithImpl<$Res, $Val extends HomePageData>
    implements $HomePageDataCopyWith<$Res> {
  _$HomePageDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceList = null,
    Object? scenarios = null,
    Object? firstSectionBanners = null,
    Object? taxTools = null,
    Object? event = freezed,
    Object? blogs = null,
  }) {
    return _then(_value.copyWith(
      serviceList: null == serviceList
          ? _value.serviceList
          : serviceList // ignore: cast_nullable_to_non_nullable
              as List<Service>,
      scenarios: null == scenarios
          ? _value.scenarios
          : scenarios // ignore: cast_nullable_to_non_nullable
              as List<Scenario>,
      firstSectionBanners: null == firstSectionBanners
          ? _value.firstSectionBanners
          : firstSectionBanners // ignore: cast_nullable_to_non_nullable
              as List<Banner>,
      taxTools: null == taxTools
          ? _value.taxTools
          : taxTools // ignore: cast_nullable_to_non_nullable
              as List<TaxTool>,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as Event?,
      blogs: null == blogs
          ? _value.blogs
          : blogs // ignore: cast_nullable_to_non_nullable
              as List<Blog>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EventCopyWith<$Res>? get event {
    if (_value.event == null) {
      return null;
    }

    return $EventCopyWith<$Res>(_value.event!, (value) {
      return _then(_value.copyWith(event: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomePageDataImplCopyWith<$Res>
    implements $HomePageDataCopyWith<$Res> {
  factory _$$HomePageDataImplCopyWith(
          _$HomePageDataImpl value, $Res Function(_$HomePageDataImpl) then) =
      __$$HomePageDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Service> serviceList,
      List<Scenario> scenarios,
      List<Banner> firstSectionBanners,
      List<TaxTool> taxTools,
      Event? event,
      List<Blog> blogs});

  @override
  $EventCopyWith<$Res>? get event;
}

/// @nodoc
class __$$HomePageDataImplCopyWithImpl<$Res>
    extends _$HomePageDataCopyWithImpl<$Res, _$HomePageDataImpl>
    implements _$$HomePageDataImplCopyWith<$Res> {
  __$$HomePageDataImplCopyWithImpl(
      _$HomePageDataImpl _value, $Res Function(_$HomePageDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceList = null,
    Object? scenarios = null,
    Object? firstSectionBanners = null,
    Object? taxTools = null,
    Object? event = freezed,
    Object? blogs = null,
  }) {
    return _then(_$HomePageDataImpl(
      serviceList: null == serviceList
          ? _value._serviceList
          : serviceList // ignore: cast_nullable_to_non_nullable
              as List<Service>,
      scenarios: null == scenarios
          ? _value._scenarios
          : scenarios // ignore: cast_nullable_to_non_nullable
              as List<Scenario>,
      firstSectionBanners: null == firstSectionBanners
          ? _value._firstSectionBanners
          : firstSectionBanners // ignore: cast_nullable_to_non_nullable
              as List<Banner>,
      taxTools: null == taxTools
          ? _value._taxTools
          : taxTools // ignore: cast_nullable_to_non_nullable
              as List<TaxTool>,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as Event?,
      blogs: null == blogs
          ? _value._blogs
          : blogs // ignore: cast_nullable_to_non_nullable
              as List<Blog>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomePageDataImpl implements _HomePageData {
  const _$HomePageDataImpl(
      {required final List<Service> serviceList,
      required final List<Scenario> scenarios,
      required final List<Banner> firstSectionBanners,
      required final List<TaxTool> taxTools,
      this.event,
      required final List<Blog> blogs})
      : _serviceList = serviceList,
        _scenarios = scenarios,
        _firstSectionBanners = firstSectionBanners,
        _taxTools = taxTools,
        _blogs = blogs;

  factory _$HomePageDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomePageDataImplFromJson(json);

  final List<Service> _serviceList;
  @override
  List<Service> get serviceList {
    if (_serviceList is EqualUnmodifiableListView) return _serviceList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_serviceList);
  }

  final List<Scenario> _scenarios;
  @override
  List<Scenario> get scenarios {
    if (_scenarios is EqualUnmodifiableListView) return _scenarios;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scenarios);
  }

  final List<Banner> _firstSectionBanners;
  @override
  List<Banner> get firstSectionBanners {
    if (_firstSectionBanners is EqualUnmodifiableListView)
      return _firstSectionBanners;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_firstSectionBanners);
  }

  final List<TaxTool> _taxTools;
  @override
  List<TaxTool> get taxTools {
    if (_taxTools is EqualUnmodifiableListView) return _taxTools;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taxTools);
  }

  @override
  final Event? event;
  final List<Blog> _blogs;
  @override
  List<Blog> get blogs {
    if (_blogs is EqualUnmodifiableListView) return _blogs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blogs);
  }

  @override
  String toString() {
    return 'HomePageData(serviceList: $serviceList, scenarios: $scenarios, firstSectionBanners: $firstSectionBanners, taxTools: $taxTools, event: $event, blogs: $blogs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomePageDataImpl &&
            const DeepCollectionEquality()
                .equals(other._serviceList, _serviceList) &&
            const DeepCollectionEquality()
                .equals(other._scenarios, _scenarios) &&
            const DeepCollectionEquality()
                .equals(other._firstSectionBanners, _firstSectionBanners) &&
            const DeepCollectionEquality().equals(other._taxTools, _taxTools) &&
            (identical(other.event, event) || other.event == event) &&
            const DeepCollectionEquality().equals(other._blogs, _blogs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_serviceList),
      const DeepCollectionEquality().hash(_scenarios),
      const DeepCollectionEquality().hash(_firstSectionBanners),
      const DeepCollectionEquality().hash(_taxTools),
      event,
      const DeepCollectionEquality().hash(_blogs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomePageDataImplCopyWith<_$HomePageDataImpl> get copyWith =>
      __$$HomePageDataImplCopyWithImpl<_$HomePageDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomePageDataImplToJson(
      this,
    );
  }
}

abstract class _HomePageData implements HomePageData {
  const factory _HomePageData(
      {required final List<Service> serviceList,
      required final List<Scenario> scenarios,
      required final List<Banner> firstSectionBanners,
      required final List<TaxTool> taxTools,
      final Event? event,
      required final List<Blog> blogs}) = _$HomePageDataImpl;

  factory _HomePageData.fromJson(Map<String, dynamic> json) =
      _$HomePageDataImpl.fromJson;

  @override
  List<Service> get serviceList;
  @override
  List<Scenario> get scenarios;
  @override
  List<Banner> get firstSectionBanners;
  @override
  List<TaxTool> get taxTools;
  @override
  Event? get event;
  @override
  List<Blog> get blogs;
  @override
  @JsonKey(ignore: true)
  _$$HomePageDataImplCopyWith<_$HomePageDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Service _$ServiceFromJson(Map<String, dynamic> json) {
  return _Service.fromJson(json);
}

/// @nodoc
mixin _$Service {
  String get service => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServiceCopyWith<Service> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceCopyWith<$Res> {
  factory $ServiceCopyWith(Service value, $Res Function(Service) then) =
      _$ServiceCopyWithImpl<$Res, Service>;
  @useResult
  $Res call({String service, String? url, String? image});
}

/// @nodoc
class _$ServiceCopyWithImpl<$Res, $Val extends Service>
    implements $ServiceCopyWith<$Res> {
  _$ServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? service = null,
    Object? url = freezed,
    Object? image = freezed,
  }) {
    return _then(_value.copyWith(
      service: null == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceImplCopyWith<$Res> implements $ServiceCopyWith<$Res> {
  factory _$$ServiceImplCopyWith(
          _$ServiceImpl value, $Res Function(_$ServiceImpl) then) =
      __$$ServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String service, String? url, String? image});
}

/// @nodoc
class __$$ServiceImplCopyWithImpl<$Res>
    extends _$ServiceCopyWithImpl<$Res, _$ServiceImpl>
    implements _$$ServiceImplCopyWith<$Res> {
  __$$ServiceImplCopyWithImpl(
      _$ServiceImpl _value, $Res Function(_$ServiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? service = null,
    Object? url = freezed,
    Object? image = freezed,
  }) {
    return _then(_$ServiceImpl(
      service: null == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceImpl implements _Service {
  const _$ServiceImpl({required this.service, this.url, this.image});

  factory _$ServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceImplFromJson(json);

  @override
  final String service;
  @override
  final String? url;
  @override
  final String? image;

  @override
  String toString() {
    return 'Service(service: $service, url: $url, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceImpl &&
            (identical(other.service, service) || other.service == service) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, service, url, image);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceImplCopyWith<_$ServiceImpl> get copyWith =>
      __$$ServiceImplCopyWithImpl<_$ServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceImplToJson(
      this,
    );
  }
}

abstract class _Service implements Service {
  const factory _Service(
      {required final String service,
      final String? url,
      final String? image}) = _$ServiceImpl;

  factory _Service.fromJson(Map<String, dynamic> json) = _$ServiceImpl.fromJson;

  @override
  String get service;
  @override
  String? get url;
  @override
  String? get image;
  @override
  @JsonKey(ignore: true)
  _$$ServiceImplCopyWith<_$ServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Scenario _$ScenarioFromJson(Map<String, dynamic> json) {
  return _Scenario.fromJson(json);
}

/// @nodoc
mixin _$Scenario {
  String get scenario => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScenarioCopyWith<Scenario> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScenarioCopyWith<$Res> {
  factory $ScenarioCopyWith(Scenario value, $Res Function(Scenario) then) =
      _$ScenarioCopyWithImpl<$Res, Scenario>;
  @useResult
  $Res call({String scenario, String? url});
}

/// @nodoc
class _$ScenarioCopyWithImpl<$Res, $Val extends Scenario>
    implements $ScenarioCopyWith<$Res> {
  _$ScenarioCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scenario = null,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      scenario: null == scenario
          ? _value.scenario
          : scenario // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScenarioImplCopyWith<$Res>
    implements $ScenarioCopyWith<$Res> {
  factory _$$ScenarioImplCopyWith(
          _$ScenarioImpl value, $Res Function(_$ScenarioImpl) then) =
      __$$ScenarioImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String scenario, String? url});
}

/// @nodoc
class __$$ScenarioImplCopyWithImpl<$Res>
    extends _$ScenarioCopyWithImpl<$Res, _$ScenarioImpl>
    implements _$$ScenarioImplCopyWith<$Res> {
  __$$ScenarioImplCopyWithImpl(
      _$ScenarioImpl _value, $Res Function(_$ScenarioImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scenario = null,
    Object? url = freezed,
  }) {
    return _then(_$ScenarioImpl(
      scenario: null == scenario
          ? _value.scenario
          : scenario // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScenarioImpl implements _Scenario {
  const _$ScenarioImpl({required this.scenario, this.url});

  factory _$ScenarioImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScenarioImplFromJson(json);

  @override
  final String scenario;
  @override
  final String? url;

  @override
  String toString() {
    return 'Scenario(scenario: $scenario, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScenarioImpl &&
            (identical(other.scenario, scenario) ||
                other.scenario == scenario) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, scenario, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScenarioImplCopyWith<_$ScenarioImpl> get copyWith =>
      __$$ScenarioImplCopyWithImpl<_$ScenarioImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScenarioImplToJson(
      this,
    );
  }
}

abstract class _Scenario implements Scenario {
  const factory _Scenario({required final String scenario, final String? url}) =
      _$ScenarioImpl;

  factory _Scenario.fromJson(Map<String, dynamic> json) =
      _$ScenarioImpl.fromJson;

  @override
  String get scenario;
  @override
  String? get url;
  @override
  @JsonKey(ignore: true)
  _$$ScenarioImplCopyWith<_$ScenarioImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Banner _$BannerFromJson(Map<String, dynamic> json) {
  return _Banner.fromJson(json);
}

/// @nodoc
mixin _$Banner {
  String get title => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  String? get button => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BannerCopyWith<Banner> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BannerCopyWith<$Res> {
  factory $BannerCopyWith(Banner value, $Res Function(Banner) then) =
      _$BannerCopyWithImpl<$Res, Banner>;
  @useResult
  $Res call(
      {String title, String label, String? url, String image, String? button});
}

/// @nodoc
class _$BannerCopyWithImpl<$Res, $Val extends Banner>
    implements $BannerCopyWith<$Res> {
  _$BannerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? label = null,
    Object? url = freezed,
    Object? image = null,
    Object? button = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      button: freezed == button
          ? _value.button
          : button // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BannerImplCopyWith<$Res> implements $BannerCopyWith<$Res> {
  factory _$$BannerImplCopyWith(
          _$BannerImpl value, $Res Function(_$BannerImpl) then) =
      __$$BannerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title, String label, String? url, String image, String? button});
}

/// @nodoc
class __$$BannerImplCopyWithImpl<$Res>
    extends _$BannerCopyWithImpl<$Res, _$BannerImpl>
    implements _$$BannerImplCopyWith<$Res> {
  __$$BannerImplCopyWithImpl(
      _$BannerImpl _value, $Res Function(_$BannerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? label = null,
    Object? url = freezed,
    Object? image = null,
    Object? button = freezed,
  }) {
    return _then(_$BannerImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      button: freezed == button
          ? _value.button
          : button // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BannerImpl implements _Banner {
  const _$BannerImpl(
      {required this.title,
      required this.label,
      this.url,
      required this.image,
      this.button});

  factory _$BannerImpl.fromJson(Map<String, dynamic> json) =>
      _$$BannerImplFromJson(json);

  @override
  final String title;
  @override
  final String label;
  @override
  final String? url;
  @override
  final String image;
  @override
  final String? button;

  @override
  String toString() {
    return 'Banner(title: $title, label: $label, url: $url, image: $image, button: $button)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BannerImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.button, button) || other.button == button));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, label, url, image, button);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BannerImplCopyWith<_$BannerImpl> get copyWith =>
      __$$BannerImplCopyWithImpl<_$BannerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BannerImplToJson(
      this,
    );
  }
}

abstract class _Banner implements Banner {
  const factory _Banner(
      {required final String title,
      required final String label,
      final String? url,
      required final String image,
      final String? button}) = _$BannerImpl;

  factory _Banner.fromJson(Map<String, dynamic> json) = _$BannerImpl.fromJson;

  @override
  String get title;
  @override
  String get label;
  @override
  String? get url;
  @override
  String get image;
  @override
  String? get button;
  @override
  @JsonKey(ignore: true)
  _$$BannerImplCopyWith<_$BannerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaxTool _$TaxToolFromJson(Map<String, dynamic> json) {
  return _TaxTool.fromJson(json);
}

/// @nodoc
mixin _$TaxTool {
  String get title => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaxToolCopyWith<TaxTool> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaxToolCopyWith<$Res> {
  factory $TaxToolCopyWith(TaxTool value, $Res Function(TaxTool) then) =
      _$TaxToolCopyWithImpl<$Res, TaxTool>;
  @useResult
  $Res call({String title, String? url, String? image});
}

/// @nodoc
class _$TaxToolCopyWithImpl<$Res, $Val extends TaxTool>
    implements $TaxToolCopyWith<$Res> {
  _$TaxToolCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? url = freezed,
    Object? image = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaxToolImplCopyWith<$Res> implements $TaxToolCopyWith<$Res> {
  factory _$$TaxToolImplCopyWith(
          _$TaxToolImpl value, $Res Function(_$TaxToolImpl) then) =
      __$$TaxToolImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String? url, String? image});
}

/// @nodoc
class __$$TaxToolImplCopyWithImpl<$Res>
    extends _$TaxToolCopyWithImpl<$Res, _$TaxToolImpl>
    implements _$$TaxToolImplCopyWith<$Res> {
  __$$TaxToolImplCopyWithImpl(
      _$TaxToolImpl _value, $Res Function(_$TaxToolImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? url = freezed,
    Object? image = freezed,
  }) {
    return _then(_$TaxToolImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaxToolImpl implements _TaxTool {
  const _$TaxToolImpl({required this.title, this.url, this.image});

  factory _$TaxToolImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaxToolImplFromJson(json);

  @override
  final String title;
  @override
  final String? url;
  @override
  final String? image;

  @override
  String toString() {
    return 'TaxTool(title: $title, url: $url, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaxToolImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, url, image);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaxToolImplCopyWith<_$TaxToolImpl> get copyWith =>
      __$$TaxToolImplCopyWithImpl<_$TaxToolImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaxToolImplToJson(
      this,
    );
  }
}

abstract class _TaxTool implements TaxTool {
  const factory _TaxTool(
      {required final String title,
      final String? url,
      final String? image}) = _$TaxToolImpl;

  factory _TaxTool.fromJson(Map<String, dynamic> json) = _$TaxToolImpl.fromJson;

  @override
  String get title;
  @override
  String? get url;
  @override
  String? get image;
  @override
  @JsonKey(ignore: true)
  _$$TaxToolImplCopyWith<_$TaxToolImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Event _$EventFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$Event {
  String get title => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String get banner => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String? get price => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res, Event>;
  @useResult
  $Res call(
      {String title,
      String? type,
      String banner,
      String date,
      String time,
      String location,
      String? price});
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? type = freezed,
    Object? banner = null,
    Object? date = null,
    Object? time = null,
    Object? location = null,
    Object? price = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      banner: null == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventImplCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$EventImplCopyWith(
          _$EventImpl value, $Res Function(_$EventImpl) then) =
      __$$EventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String? type,
      String banner,
      String date,
      String time,
      String location,
      String? price});
}

/// @nodoc
class __$$EventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$EventImpl>
    implements _$$EventImplCopyWith<$Res> {
  __$$EventImplCopyWithImpl(
      _$EventImpl _value, $Res Function(_$EventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? type = freezed,
    Object? banner = null,
    Object? date = null,
    Object? time = null,
    Object? location = null,
    Object? price = freezed,
  }) {
    return _then(_$EventImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      banner: null == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventImpl implements _Event {
  const _$EventImpl(
      {required this.title,
      this.type,
      required this.banner,
      required this.date,
      required this.time,
      required this.location,
      this.price});

  factory _$EventImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImplFromJson(json);

  @override
  final String title;
  @override
  final String? type;
  @override
  final String banner;
  @override
  final String date;
  @override
  final String time;
  @override
  final String location;
  @override
  final String? price;

  @override
  String toString() {
    return 'Event(title: $title, type: $type, banner: $banner, date: $date, time: $time, location: $location, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.banner, banner) || other.banner == banner) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, title, type, banner, date, time, location, price);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      __$$EventImplCopyWithImpl<_$EventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImplToJson(
      this,
    );
  }
}

abstract class _Event implements Event {
  const factory _Event(
      {required final String title,
      final String? type,
      required final String banner,
      required final String date,
      required final String time,
      required final String location,
      final String? price}) = _$EventImpl;

  factory _Event.fromJson(Map<String, dynamic> json) = _$EventImpl.fromJson;

  @override
  String get title;
  @override
  String? get type;
  @override
  String get banner;
  @override
  String get date;
  @override
  String get time;
  @override
  String get location;
  @override
  String? get price;
  @override
  @JsonKey(ignore: true)
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Blog _$BlogFromJson(Map<String, dynamic> json) {
  return _Blog.fromJson(json);
}

/// @nodoc
mixin _$Blog {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'short_description')
  String? get shortDescription => throw _privateConstructorUsedError;
  String? get author => throw _privateConstructorUsedError;
  @JsonKey(name: 'posted_date')
  DateTime? get postedDate => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'sub_category')
  String? get subCategory => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_text')
  String? get statusText => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BlogCopyWith<Blog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlogCopyWith<$Res> {
  factory $BlogCopyWith(Blog value, $Res Function(Blog) then) =
      _$BlogCopyWithImpl<$Res, Blog>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? url,
      @JsonKey(name: 'short_description') String? shortDescription,
      String? author,
      @JsonKey(name: 'posted_date') DateTime? postedDate,
      List<String>? tags,
      String? thumbnail,
      String? category,
      @JsonKey(name: 'sub_category') String? subCategory,
      @JsonKey(name: 'status_text') String? statusText});
}

/// @nodoc
class _$BlogCopyWithImpl<$Res, $Val extends Blog>
    implements $BlogCopyWith<$Res> {
  _$BlogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? url = freezed,
    Object? shortDescription = freezed,
    Object? author = freezed,
    Object? postedDate = freezed,
    Object? tags = freezed,
    Object? thumbnail = freezed,
    Object? category = freezed,
    Object? subCategory = freezed,
    Object? statusText = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      shortDescription: freezed == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      postedDate: freezed == postedDate
          ? _value.postedDate
          : postedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      subCategory: freezed == subCategory
          ? _value.subCategory
          : subCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      statusText: freezed == statusText
          ? _value.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BlogImplCopyWith<$Res> implements $BlogCopyWith<$Res> {
  factory _$$BlogImplCopyWith(
          _$BlogImpl value, $Res Function(_$BlogImpl) then) =
      __$$BlogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? url,
      @JsonKey(name: 'short_description') String? shortDescription,
      String? author,
      @JsonKey(name: 'posted_date') DateTime? postedDate,
      List<String>? tags,
      String? thumbnail,
      String? category,
      @JsonKey(name: 'sub_category') String? subCategory,
      @JsonKey(name: 'status_text') String? statusText});
}

/// @nodoc
class __$$BlogImplCopyWithImpl<$Res>
    extends _$BlogCopyWithImpl<$Res, _$BlogImpl>
    implements _$$BlogImplCopyWith<$Res> {
  __$$BlogImplCopyWithImpl(_$BlogImpl _value, $Res Function(_$BlogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? url = freezed,
    Object? shortDescription = freezed,
    Object? author = freezed,
    Object? postedDate = freezed,
    Object? tags = freezed,
    Object? thumbnail = freezed,
    Object? category = freezed,
    Object? subCategory = freezed,
    Object? statusText = freezed,
  }) {
    return _then(_$BlogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      shortDescription: freezed == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      postedDate: freezed == postedDate
          ? _value.postedDate
          : postedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      subCategory: freezed == subCategory
          ? _value.subCategory
          : subCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      statusText: freezed == statusText
          ? _value.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BlogImpl implements _Blog {
  const _$BlogImpl(
      {required this.id,
      required this.title,
      this.url,
      @JsonKey(name: 'short_description') this.shortDescription,
      this.author,
      @JsonKey(name: 'posted_date') this.postedDate,
      final List<String>? tags,
      this.thumbnail,
      this.category,
      @JsonKey(name: 'sub_category') this.subCategory,
      @JsonKey(name: 'status_text') this.statusText})
      : _tags = tags;

  factory _$BlogImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlogImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? url;
  @override
  @JsonKey(name: 'short_description')
  final String? shortDescription;
  @override
  final String? author;
  @override
  @JsonKey(name: 'posted_date')
  final DateTime? postedDate;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? thumbnail;
  @override
  final String? category;
  @override
  @JsonKey(name: 'sub_category')
  final String? subCategory;
  @override
  @JsonKey(name: 'status_text')
  final String? statusText;

  @override
  String toString() {
    return 'Blog(id: $id, title: $title, url: $url, shortDescription: $shortDescription, author: $author, postedDate: $postedDate, tags: $tags, thumbnail: $thumbnail, category: $category, subCategory: $subCategory, statusText: $statusText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.postedDate, postedDate) ||
                other.postedDate == postedDate) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subCategory, subCategory) ||
                other.subCategory == subCategory) &&
            (identical(other.statusText, statusText) ||
                other.statusText == statusText));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      url,
      shortDescription,
      author,
      postedDate,
      const DeepCollectionEquality().hash(_tags),
      thumbnail,
      category,
      subCategory,
      statusText);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogImplCopyWith<_$BlogImpl> get copyWith =>
      __$$BlogImplCopyWithImpl<_$BlogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BlogImplToJson(
      this,
    );
  }
}

abstract class _Blog implements Blog {
  const factory _Blog(
      {required final String id,
      required final String title,
      final String? url,
      @JsonKey(name: 'short_description') final String? shortDescription,
      final String? author,
      @JsonKey(name: 'posted_date') final DateTime? postedDate,
      final List<String>? tags,
      final String? thumbnail,
      final String? category,
      @JsonKey(name: 'sub_category') final String? subCategory,
      @JsonKey(name: 'status_text') final String? statusText}) = _$BlogImpl;

  factory _Blog.fromJson(Map<String, dynamic> json) = _$BlogImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get url;
  @override
  @JsonKey(name: 'short_description')
  String? get shortDescription;
  @override
  String? get author;
  @override
  @JsonKey(name: 'posted_date')
  DateTime? get postedDate;
  @override
  List<String>? get tags;
  @override
  String? get thumbnail;
  @override
  String? get category;
  @override
  @JsonKey(name: 'sub_category')
  String? get subCategory;
  @override
  @JsonKey(name: 'status_text')
  String? get statusText;
  @override
  @JsonKey(ignore: true)
  _$$BlogImplCopyWith<_$BlogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
