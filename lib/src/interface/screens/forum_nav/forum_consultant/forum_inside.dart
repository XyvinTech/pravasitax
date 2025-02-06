import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravasitax_flutter/src/data/models/forum_model.dart';
import 'package:pravasitax_flutter/src/data/providers/forum_provider.dart';
import 'package:pravasitax_flutter/src/interface/widgets/loading_indicator.dart';

class ForumInside extends ConsumerStatefulWidget {
  final ForumThread thread;
  final String userToken;

  ForumInside({required this.thread, required this.userToken});

  @override
  _ForumInsideState createState() => _ForumInsideState();
}

class _ForumInsideState extends ConsumerState<ForumInside> {
  final TextEditingController _commentController = TextEditingController();
  String? replyingTo;
  bool isLiked = false;
  int likeCount = 25;

  void _toggleLike() {
    setState(() {
      if (isLiked) {
        likeCount--;
      } else {
        likeCount++;
      }
      isLiked = !isLiked;
    });
  }

  void _addReply(String content, {String? parentPostId}) async {
    try {
      await ref.read(createPostProvider((
        userToken: widget.userToken,
        threadId: widget.thread.id,
        content: content,
        parentPostId: parentPostId,
      )).future);

      // Always refresh the main posts list to update reply counts
      ref.refresh(forumPostsProvider((
        userToken: widget.userToken,
        threadId: widget.thread.id,
      )));

      // If this is a nested reply, refresh the parent's replies
      if (parentPostId != null) {
        // Refresh immediate parent's replies
        ref.refresh(postRepliesProvider((
          userToken: widget.userToken,
          threadId: widget.thread.id,
          parentPostId: parentPostId,
        )));

        // Get the parent post to check if it has a parent
        final parentPost = await ref.read(postRepliesProvider((
          userToken: widget.userToken,
          threadId: widget.thread.id,
          parentPostId: parentPostId,
        )).future);

        // If parent has a parent, refresh grandparent's replies
        if (parentPost.isNotEmpty && parentPost[0].parentPostId != null) {
          ref.refresh(postRepliesProvider((
            userToken: widget.userToken,
            threadId: widget.thread.id,
            parentPostId: parentPost[0].parentPostId!,
          )));
        }
      }

      _commentController.clear();
      replyingTo = null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add reply: $e')),
      );
    }
  }

  void _showReplyModal(BuildContext context, String? parentPostId) {
    _commentController.clear();
    final primaryColor = Color(0xFFF9B406);

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    parentPostId == null ? 'Add Comment' : 'Add Reply',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    color: Colors.black54,
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: parentPostId == null
                      ? 'Write your comment...'
                      : 'Write your reply...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: EdgeInsets.all(16),
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_commentController.text.isNotEmpty) {
                    _addReply(_commentController.text,
                        parentPostId: parentPostId);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReplies(List<ForumPost> replies, int depth) {
    const int maxDepth = 3;
    const double maxIndent = 48.0;

    // Calculate font size based on depth
    double getFontSize(int depth) {
      const baseFontSize = 15.0;
      return baseFontSize -
          (depth * 0.5); // Decrease font size by 0.5 for each level
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: replies.length,
      itemBuilder: (context, index) {
        final reply = replies[index];
        double indentation = depth * 16.0;
        if (indentation > maxIndent) {
          indentation = maxIndent;
        }

        return Container(
          margin: EdgeInsets.only(
            left: indentation,
            top: 8.0,
            bottom: 8.0,
          ),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                width: 2.0,
              ),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onLongPress: () {
                _showReplyModal(context, reply.id);
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          radius: depth == 0 ? 16 : 14,
                          child: Text(
                            reply.authorName[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: depth == 0 ? 14 : 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      reply.authorName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: getFontSize(depth),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _formatTime(reply.createdAt),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                      fontSize: getFontSize(depth) - 2,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                reply.content,
                                style: TextStyle(
                                  fontSize: getFontSize(depth),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.9),
                                ),
                                maxLines: depth == 0 ? 10 : 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        _showReplyModal(context, reply.id),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: depth == 0 ? 12 : 8,
                                        vertical: depth == 0 ? 6 : 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.reply,
                                            size: depth == 0 ? 16 : 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Reply',
                                            style: TextStyle(
                                              fontSize: getFontSize(depth) - 2,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (reply.replyCount > 0)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: depth == 0 ? 12 : 8),
                                      child: Text(
                                        '${reply.replyCount} ${reply.replyCount == 1 ? 'reply' : 'replies'}',
                                        style: TextStyle(
                                          fontSize: getFontSize(depth) - 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (depth < maxDepth && reply.replies.isNotEmpty)
                      _buildReplies(reply.replies, depth + 1)
                    else if (reply.replies.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 8.0),
                        child: InkWell(
                          onTap: () => _showContinueThread(reply),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.subdirectory_arrow_right,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Continue thread',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showContinueThread(ForumPost parentPost) {
    final primaryColor = Color(0xFFF9B406);
    final primaryLightColor = Color(0xFFF9B406).withOpacity(0.1);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                            color: Colors.black54,
                          ),
                          Text(
                            'Continued Thread',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 48), // Balance the close button
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        // Parent post
                        Container(
                          margin: EdgeInsets.all(16),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: primaryLightColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 16,
                                    child: Text(
                                      parentPost.authorName[0].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          parentPost.authorName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          _formatTime(parentPost.createdAt),
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                parentPost.content,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Consumer(
                            builder: (context, ref, child) {
                              final repliesAsync =
                                  ref.watch(postRepliesProvider((
                                userToken: widget.userToken,
                                threadId: widget.thread.id,
                                parentPostId: parentPost.id,
                              )));

                              return repliesAsync.when(
                                loading: () =>
                                    Center(child: LoadingIndicator()),
                                error: (error, stack) => Center(
                                  child: Text(
                                    'Error: $error',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                data: (replies) => _buildReplies(replies, 0),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(forumPostsProvider((
      userToken: widget.userToken,
      threadId: widget.thread.id,
    )));

    final primaryColor = Color(0xFFF9B406);
    final primaryLightColor = Color(0xFFF9B406).withOpacity(0.1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.thread.title,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Main Post
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryLightColor,
                      radius: 20,
                      child: Text(
                        (widget.thread.authorName ?? widget.thread.userId)[0]
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.thread.authorName ?? widget.thread.userId,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            _formatTime(widget.thread.createdAt),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  widget.thread.description,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                if (widget.thread.image != null) ...[
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: EdgeInsets.zero,
                          child: Stack(
                            fit: StackFit.loose,
                            children: [
                              InteractiveViewer(
                                minScale: 0.5,
                                maxScale: 4,
                                child: Image.network(
                                  widget.thread.image!,
                                  fit: BoxFit.contain,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                ),
                              ),
                              Positioned(
                                top: 40,
                                right: 20,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.close,
                                        color: Colors.white, size: 30),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 200, // Fixed height
                        width: double.infinity,
                        child: Image.network(
                          widget.thread.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.grey[400],
                                size: 32,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 16),
                Row(
                  children: [
                    // _buildActionButton(
                    //   onTap: _toggleLike,
                    //   icon: isLiked ? Icons.favorite : Icons.favorite_border,
                    //   iconColor: isLiked ? Colors.red : Colors.grey[600]!,
                    //   text: '$likeCount',
                    //   backgroundColor: primaryLightColor,
                    // ),
                    // SizedBox(width: 12),
                    // _buildActionButton(
                    //   onTap: () {},
                    //   icon: Icons.comment_outlined,
                    //   iconColor: Colors.grey[600]!,
                    //   text: '${widget.thread.postCount}',
                    //   backgroundColor: primaryLightColor,
                    // ),
                    Spacer(),
                    TextButton.icon(
                      onPressed: () => _showReplyModal(context, null),
                      icon: Icon(Icons.reply, size: 20, color: primaryColor),
                      label: Text(
                        'Reply',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: primaryLightColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Replies',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 8),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                //   decoration: BoxDecoration(
                //     color: primaryLightColor,
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Text(
                //     '${widget.thread.postCount}',
                //     style: TextStyle(
                //       color: primaryColor,
                //       fontWeight: FontWeight.w600,
                //       fontSize: 12,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(height: 8),

          // Comments Section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: postsAsync.when(
                      loading: () => Center(child: LoadingIndicator()),
                      error: (error, stack) => Center(
                        child: Text(
                          'Error: $error',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      data: (posts) => _buildReplies(posts, 0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showReplyModal(context, null),
        backgroundColor: primaryColor,
        child: Icon(Icons.add_comment_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color iconColor,
    required String text,
    required Color backgroundColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4),
            Icon(icon, size: 18, color: iconColor),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}h ago';
    } else {
      return '${duration.inDays}d ago';
    }
  }
}
