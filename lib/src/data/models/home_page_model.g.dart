// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomePageDataImpl _$$HomePageDataImplFromJson(Map<String, dynamic> json) =>
    _$HomePageDataImpl(
      serviceList: (json['serviceList'] as List<dynamic>)
          .map((e) => Service.fromJson(e as Map<String, dynamic>))
          .toList(),
      scenarios: (json['scenarios'] as List<dynamic>)
          .map((e) => Scenario.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstSectionBanners: (json['firstSectionBanners'] as List<dynamic>)
          .map((e) => Banner.fromJson(e as Map<String, dynamic>))
          .toList(),
      taxTools: (json['taxTools'] as List<dynamic>)
          .map((e) => TaxTool.fromJson(e as Map<String, dynamic>))
          .toList(),
      event: json['event'] == null
          ? null
          : Event.fromJson(json['event'] as Map<String, dynamic>),
      blogs: (json['blogs'] as List<dynamic>)
          .map((e) => Blog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$HomePageDataImplToJson(_$HomePageDataImpl instance) =>
    <String, dynamic>{
      'serviceList': instance.serviceList,
      'scenarios': instance.scenarios,
      'firstSectionBanners': instance.firstSectionBanners,
      'taxTools': instance.taxTools,
      'event': instance.event,
      'blogs': instance.blogs,
    };

_$ServiceImpl _$$ServiceImplFromJson(Map<String, dynamic> json) =>
    _$ServiceImpl(
      service: json['service'] as String,
      url: json['url'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$ServiceImplToJson(_$ServiceImpl instance) =>
    <String, dynamic>{
      'service': instance.service,
      'url': instance.url,
      'image': instance.image,
    };

_$ScenarioImpl _$$ScenarioImplFromJson(Map<String, dynamic> json) =>
    _$ScenarioImpl(
      scenario: json['scenario'] as String,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$ScenarioImplToJson(_$ScenarioImpl instance) =>
    <String, dynamic>{
      'scenario': instance.scenario,
      'url': instance.url,
    };

_$BannerImpl _$$BannerImplFromJson(Map<String, dynamic> json) => _$BannerImpl(
      title: json['title'] as String,
      label: json['label'] as String,
      url: json['url'] as String?,
      image: json['image'] as String,
      button: json['button'] as String?,
    );

Map<String, dynamic> _$$BannerImplToJson(_$BannerImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'label': instance.label,
      'url': instance.url,
      'image': instance.image,
      'button': instance.button,
    };

_$TaxToolImpl _$$TaxToolImplFromJson(Map<String, dynamic> json) =>
    _$TaxToolImpl(
      title: json['title'] as String,
      url: json['url'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$TaxToolImplToJson(_$TaxToolImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'image': instance.image,
    };

_$EventImpl _$$EventImplFromJson(Map<String, dynamic> json) => _$EventImpl(
      title: json['title'] as String,
      type: json['type'] as String?,
      banner: json['banner'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      location: json['location'] as String,
      price: json['price'] as String?,
    );

Map<String, dynamic> _$$EventImplToJson(_$EventImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'type': instance.type,
      'banner': instance.banner,
      'date': instance.date,
      'time': instance.time,
      'location': instance.location,
      'price': instance.price,
    };

_$BlogImpl _$$BlogImplFromJson(Map<String, dynamic> json) => _$BlogImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String?,
      shortDescription: json['short_description'] as String?,
      author: json['author'] as String?,
      postedDate: json['posted_date'] == null
          ? null
          : DateTime.parse(json['posted_date'] as String),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      thumbnail: json['thumbnail'] as String?,
      category: json['category'] as String?,
      subCategory: json['sub_category'] as String?,
      statusText: json['status_text'] as String?,
    );

Map<String, dynamic> _$$BlogImplToJson(_$BlogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'short_description': instance.shortDescription,
      'author': instance.author,
      'posted_date': instance.postedDate?.toIso8601String(),
      'tags': instance.tags,
      'thumbnail': instance.thumbnail,
      'category': instance.category,
      'sub_category': instance.subCategory,
      'status_text': instance.statusText,
    };
