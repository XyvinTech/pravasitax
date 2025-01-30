// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return _Article.fromJson(json);
}

/// @nodoc
mixin _$Article {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get shortDescription => throw _privateConstructorUsedError;
  String? get author => throw _privateConstructorUsedError;
  DateTime? get postedDate => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get subCategory => throw _privateConstructorUsedError;
  String? get statusText => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ArticleCopyWith<Article> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleCopyWith<$Res> {
  factory $ArticleCopyWith(Article value, $Res Function(Article) then) =
      _$ArticleCopyWithImpl<$Res, Article>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? shortDescription,
      String? author,
      DateTime? postedDate,
      List<String>? tags,
      String? thumbnail,
      String category,
      String? subCategory,
      String? statusText,
      String? url,
      String? content});
}

/// @nodoc
class _$ArticleCopyWithImpl<$Res, $Val extends Article>
    implements $ArticleCopyWith<$Res> {
  _$ArticleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? shortDescription = freezed,
    Object? author = freezed,
    Object? postedDate = freezed,
    Object? tags = freezed,
    Object? thumbnail = freezed,
    Object? category = null,
    Object? subCategory = freezed,
    Object? statusText = freezed,
    Object? url = freezed,
    Object? content = freezed,
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      subCategory: freezed == subCategory
          ? _value.subCategory
          : subCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      statusText: freezed == statusText
          ? _value.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArticleImplCopyWith<$Res> implements $ArticleCopyWith<$Res> {
  factory _$$ArticleImplCopyWith(
          _$ArticleImpl value, $Res Function(_$ArticleImpl) then) =
      __$$ArticleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? shortDescription,
      String? author,
      DateTime? postedDate,
      List<String>? tags,
      String? thumbnail,
      String category,
      String? subCategory,
      String? statusText,
      String? url,
      String? content});
}

/// @nodoc
class __$$ArticleImplCopyWithImpl<$Res>
    extends _$ArticleCopyWithImpl<$Res, _$ArticleImpl>
    implements _$$ArticleImplCopyWith<$Res> {
  __$$ArticleImplCopyWithImpl(
      _$ArticleImpl _value, $Res Function(_$ArticleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? shortDescription = freezed,
    Object? author = freezed,
    Object? postedDate = freezed,
    Object? tags = freezed,
    Object? thumbnail = freezed,
    Object? category = null,
    Object? subCategory = freezed,
    Object? statusText = freezed,
    Object? url = freezed,
    Object? content = freezed,
  }) {
    return _then(_$ArticleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      subCategory: freezed == subCategory
          ? _value.subCategory
          : subCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      statusText: freezed == statusText
          ? _value.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArticleImpl implements _Article {
  _$ArticleImpl(
      {required this.id,
      required this.title,
      this.shortDescription,
      this.author,
      this.postedDate,
      final List<String>? tags,
      this.thumbnail,
      required this.category,
      this.subCategory,
      this.statusText,
      this.url,
      this.content})
      : _tags = tags;

  factory _$ArticleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticleImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? shortDescription;
  @override
  final String? author;
  @override
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
  final String category;
  @override
  final String? subCategory;
  @override
  final String? statusText;
  @override
  final String? url;
  @override
  final String? content;

  @override
  String toString() {
    return 'Article(id: $id, title: $title, shortDescription: $shortDescription, author: $author, postedDate: $postedDate, tags: $tags, thumbnail: $thumbnail, category: $category, subCategory: $subCategory, statusText: $statusText, url: $url, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
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
                other.statusText == statusText) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      shortDescription,
      author,
      postedDate,
      const DeepCollectionEquality().hash(_tags),
      thumbnail,
      category,
      subCategory,
      statusText,
      url,
      content);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticleImplCopyWith<_$ArticleImpl> get copyWith =>
      __$$ArticleImplCopyWithImpl<_$ArticleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticleImplToJson(
      this,
    );
  }
}

abstract class _Article implements Article {
  factory _Article(
      {required final String id,
      required final String title,
      final String? shortDescription,
      final String? author,
      final DateTime? postedDate,
      final List<String>? tags,
      final String? thumbnail,
      required final String category,
      final String? subCategory,
      final String? statusText,
      final String? url,
      final String? content}) = _$ArticleImpl;

  factory _Article.fromJson(Map<String, dynamic> json) = _$ArticleImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get shortDescription;
  @override
  String? get author;
  @override
  DateTime? get postedDate;
  @override
  List<String>? get tags;
  @override
  String? get thumbnail;
  @override
  String get category;
  @override
  String? get subCategory;
  @override
  String? get statusText;
  @override
  String? get url;
  @override
  String? get content;
  @override
  @JsonKey(ignore: true)
  _$$ArticleImplCopyWith<_$ArticleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategorySubCategory _$CategorySubCategoryFromJson(Map<String, dynamic> json) {
  return _CategorySubCategory.fromJson(json);
}

/// @nodoc
mixin _$CategorySubCategory {
  String get category => throw _privateConstructorUsedError;
  List<String> get subCategories => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategorySubCategoryCopyWith<CategorySubCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategorySubCategoryCopyWith<$Res> {
  factory $CategorySubCategoryCopyWith(
          CategorySubCategory value, $Res Function(CategorySubCategory) then) =
      _$CategorySubCategoryCopyWithImpl<$Res, CategorySubCategory>;
  @useResult
  $Res call({String category, List<String> subCategories});
}

/// @nodoc
class _$CategorySubCategoryCopyWithImpl<$Res, $Val extends CategorySubCategory>
    implements $CategorySubCategoryCopyWith<$Res> {
  _$CategorySubCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? subCategories = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      subCategories: null == subCategories
          ? _value.subCategories
          : subCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategorySubCategoryImplCopyWith<$Res>
    implements $CategorySubCategoryCopyWith<$Res> {
  factory _$$CategorySubCategoryImplCopyWith(_$CategorySubCategoryImpl value,
          $Res Function(_$CategorySubCategoryImpl) then) =
      __$$CategorySubCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String category, List<String> subCategories});
}

/// @nodoc
class __$$CategorySubCategoryImplCopyWithImpl<$Res>
    extends _$CategorySubCategoryCopyWithImpl<$Res, _$CategorySubCategoryImpl>
    implements _$$CategorySubCategoryImplCopyWith<$Res> {
  __$$CategorySubCategoryImplCopyWithImpl(_$CategorySubCategoryImpl _value,
      $Res Function(_$CategorySubCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? subCategories = null,
  }) {
    return _then(_$CategorySubCategoryImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      subCategories: null == subCategories
          ? _value._subCategories
          : subCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategorySubCategoryImpl implements _CategorySubCategory {
  _$CategorySubCategoryImpl(
      {required this.category, required final List<String> subCategories})
      : _subCategories = subCategories;

  factory _$CategorySubCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategorySubCategoryImplFromJson(json);

  @override
  final String category;
  final List<String> _subCategories;
  @override
  List<String> get subCategories {
    if (_subCategories is EqualUnmodifiableListView) return _subCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subCategories);
  }

  @override
  String toString() {
    return 'CategorySubCategory(category: $category, subCategories: $subCategories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategorySubCategoryImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality()
                .equals(other._subCategories, _subCategories));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, category,
      const DeepCollectionEquality().hash(_subCategories));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategorySubCategoryImplCopyWith<_$CategorySubCategoryImpl> get copyWith =>
      __$$CategorySubCategoryImplCopyWithImpl<_$CategorySubCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategorySubCategoryImplToJson(
      this,
    );
  }
}

abstract class _CategorySubCategory implements CategorySubCategory {
  factory _CategorySubCategory(
      {required final String category,
      required final List<String> subCategories}) = _$CategorySubCategoryImpl;

  factory _CategorySubCategory.fromJson(Map<String, dynamic> json) =
      _$CategorySubCategoryImpl.fromJson;

  @override
  String get category;
  @override
  List<String> get subCategories;
  @override
  @JsonKey(ignore: true)
  _$$CategorySubCategoryImplCopyWith<_$CategorySubCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
