import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../api/forum_api.dart';
import '../models/forum_model.dart';

final forumCategoriesProvider =
    FutureProvider.family<List<ForumCategory>, String>((ref, userToken) async {
  final api = ref.watch(forumAPIProvider);
  final categories = await api.getCategories(userToken);
  return categories.map((json) => ForumCategory.fromJson(json)).toList();
});

final forumThreadsProvider = FutureProvider.family<List<ForumThread>,
    ({String userToken, String categoryId})>((ref, params) async {
  final api = ref.watch(forumAPIProvider);
  final threads = await api.getThreads(params.userToken, params.categoryId);
  return threads.map((json) => ForumThread.fromJson(json)).toList();
});

final createThreadProvider = FutureProvider.family<
    ForumThread,
    ({
      String userToken,
      String title,
      String description,
      String categoryId,
      http.MultipartFile? postImage,
    })>((ref, params) async {
  final api = ref.watch(forumAPIProvider);
  final thread = await api.createThread(
    params.userToken,
    title: params.title,
    description: params.description,
    categoryId: params.categoryId,
    postImage: params.postImage,
  );
  return ForumThread.fromJson(thread);
});

final forumPostsProvider = FutureProvider.family<List<ForumPost>,
    ({String userToken, String threadId})>((ref, params) async {
  final api = ref.watch(forumAPIProvider);
  final posts = await api.getPosts(params.userToken, params.threadId);
  return posts.map((json) => ForumPost.fromJson(json)).toList();
});

final createPostProvider = FutureProvider.family<
    ForumPost,
    ({
      String userToken,
      String threadId,
      String content,
      String? parentPostId,
    })>((ref, params) async {
  final api = ref.watch(forumAPIProvider);
  final post = await api.createPost(
    params.userToken,
    threadId: params.threadId,
    content: params.content,
    parentPostId: params.parentPostId,
  );
  return ForumPost.fromJson(post);
});

final postRepliesProvider = FutureProvider.family<
    List<ForumPost>,
    ({
      String userToken,
      String threadId,
      String parentPostId,
    })>((ref, params) async {
  final api = ref.watch(forumAPIProvider);
  final replies = await api.getReplies(
    params.userToken,
    params.threadId,
    params.parentPostId,
  );
  return replies.map((json) => ForumPost.fromJson(json)).toList();
});

final markThreadAsClosedProvider =
    FutureProvider.family<void, ({String userToken, String threadId})>(
        (ref, params) async {
  final api = ref.watch(forumAPIProvider);
  await api.markThreadAsClosed(params.userToken, params.threadId);
});

final markThreadAsDeletedProvider =
    FutureProvider.family<void, ({String userToken, String threadId})>(
        (ref, params) async {
  final api = ref.watch(forumAPIProvider);
  await api.markThreadAsDeleted(params.userToken, params.threadId);
});

final createCategoryProvider = FutureProvider.family<Map<String, dynamic>,
    ({String userToken, String category})>((ref, params) async {
  final api = ref.watch(forumAPIProvider);
  return await api.createCategory(params.userToken, params.category);
});

final deleteCategoryProvider =
    FutureProvider.family<void, ({String userToken, String categoryId})>(
        (ref, params) async {
  final api = ref.watch(forumAPIProvider);
  await api.deleteCategory(params.userToken, params.categoryId);
});
