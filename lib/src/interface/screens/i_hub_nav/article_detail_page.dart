import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../data/providers/articles_provider.dart';
import 'package:pravasitax_flutter/src/interface/widgets/loading_indicator.dart';
class ArticleDetailPage extends ConsumerWidget {
  final String articleId;

  const ArticleDetailPage({Key? key, required this.articleId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleAsync = ref.watch(articleDetailProvider(articleId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: articleAsync.when(
        data: (article) => SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              if (article.author != null) ...[
                Text(
                  'By ${article.author}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
              ],
              if (article.postedDate != null)
                Text(
                  'Posted on ${article.postedDate!.day}/${article.postedDate!.month}/${article.postedDate!.year}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              SizedBox(height: 16),
              if (article.content != null)
                Html(
                  data: article.content!,
                  style: {
                    "body": Style(
                      fontSize: FontSize(16),
                      color: Colors.grey[800],
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                    ),
                    "p": Style(
                      margin: Margins.only(bottom: 8),
                      padding: HtmlPaddings.zero,
                    ),
                    "h1": Style(
                      fontSize: FontSize(24),
                      fontWeight: FontWeight.bold,
                      margin: Margins.only(bottom: 12, top: 16),
                    ),
                    "h2": Style(
                      fontSize: FontSize(20),
                      fontWeight: FontWeight.bold,
                      margin: Margins.only(bottom: 10, top: 14),
                    ),
                    "h3": Style(
                      fontSize: FontSize(18),
                      fontWeight: FontWeight.bold,
                      margin: Margins.only(bottom: 8, top: 12),
                    ),
                    "ul": Style(
                      margin: Margins.only(bottom: 12),
                    ),
                    "ol": Style(
                      margin: Margins.only(bottom: 12),
                    ),
                    "li": Style(
                      margin: Margins.only(bottom: 4),
                    ),
                    "img": Style(
                      width: Width(MediaQuery.of(context).size.width - 32),
                      margin: Margins.only(bottom: 12, top: 12),
                      alignment: Alignment.center,
                    ),
                    "br": Style(
                      height: Height(1), // Reduce space between breaks
                    ),
                  },
                  onLinkTap: (url, _, __) {
                    if (url != null) {
                      // Handle link taps here
                    }
                  },
                ),
              SizedBox(height: 16),
              if (article.tags != null && article.tags!.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: article.tags!
                      .map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Colors.grey[200],
                          ))
                      .toList(),
                ),
            ],
          ),
        ),
        loading: () => Center(child: LoadingIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading article: $error'),
        ),
      ),
    );
  }
}
