import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

@freezed
class Article with _$Article {
  factory Article({
    required String id,
    required String title,
    String? shortDescription,
    String? author,
    DateTime? postedDate,
    List<String>? tags,
    String? thumbnail,
    required String category,
    String? subCategory,
    String? statusText,
    String? url,
    String? content,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}

@freezed
class CategorySubCategory with _$CategorySubCategory {
  factory CategorySubCategory({
    required String category,
    required List<String> subCategories,
  }) = _CategorySubCategory;

  factory CategorySubCategory.fromJson(Map<String, dynamic> json) =>
      _$CategorySubCategoryFromJson(json);
}
