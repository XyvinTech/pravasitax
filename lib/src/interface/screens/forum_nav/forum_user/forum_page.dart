import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravasitax_flutter/src/data/models/forum_model.dart';
import 'package:pravasitax_flutter/src/data/providers/forum_provider.dart';
import 'package:pravasitax_flutter/src/interface/widgets/loading_indicator.dart';
import 'package:pravasitax_flutter/src/interface/screens/forum_nav/forum_user/forum_list.dart';

class ForumPage extends ConsumerWidget {
  final String userToken;

  ForumPage({required this.userToken});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Color(0xFFF9B406);
    final primaryLightColor = Color(0xFFF9B406).withOpacity(0.1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer(
        builder: (context, ref, child) {
          final categoriesAsync = ref.watch(forumCategoriesProvider(userToken));

          return categoriesAsync.when(
            loading: () => Center(child: LoadingIndicator()),
            error: (error, stack) => Center(
              child: Text(
                'Error: $error',
                style: TextStyle(color: Colors.red),
              ),
            ),
            data: (categories) => ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForumList(
                              category: category,
                              userToken: userToken,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: primaryLightColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.forum_outlined,
                                    color: primaryColor,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        category.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      if (category.description != null)
                                        Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            category.description!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
