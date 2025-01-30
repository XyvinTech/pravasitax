// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArticleImpl _$$ArticleImplFromJson(Map<String, dynamic> json) =>
    _$ArticleImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String?,
      author: json['author'] as String?,
      postedDate: json['postedDate'] == null
          ? null
          : DateTime.parse(json['postedDate'] as String),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      thumbnail: json['thumbnail'] as String?,
      category: json['category'] as String,
      subCategory: json['subCategory'] as String?,
      statusText: json['statusText'] as String?,
      url: json['url'] as String?,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$$ArticleImplToJson(_$ArticleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'shortDescription': instance.shortDescription,
      'author': instance.author,
      'postedDate': instance.postedDate?.toIso8601String(),
      'tags': instance.tags,
      'thumbnail': instance.thumbnail,
      'category': instance.category,
      'subCategory': instance.subCategory,
      'statusText': instance.statusText,
      'url': instance.url,
      'content': instance.content,
    };

_$CategorySubCategoryImpl _$$CategorySubCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$CategorySubCategoryImpl(
      category: json['category'] as String,
      subCategories: (json['subCategories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$CategorySubCategoryImplToJson(
        _$CategorySubCategoryImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'subCategories': instance.subCategories,
    };
