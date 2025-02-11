import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:pravasitax_flutter/src/core/theme/app_theme.dart';
import 'package:pravasitax_flutter/src/data/models/chat_model.dart';
import 'package:pravasitax_flutter/src/data/providers/chat_provider.dart';
import 'package:pravasitax_flutter/src/data/services/secure_storage_service.dart';
import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_pages/chat_info.dart';

class IndividualPage extends ConsumerStatefulWidget {
  static const Color primaryColor = Color(0xFFF8B50C);
  static const Color secondaryColor = Color(0xFF05104F);

  const IndividualPage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.conversationId,
    required this.userId,
    required this.userToken,
  });

  final String title;
  final String userId;
  final String userToken;
  final String imageUrl;
  final String conversationId;

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends ConsumerState<IndividualPage> {
  bool isBlocked = false;
  bool show = false;
  bool isEmojiVisible = false;
  final FocusNode focusNode = FocusNode();
  final List<MessageModel> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getMessageHistory();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isEmojiVisible = false;
        });
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userToken = await SecureStorageService.getAuthToken();
    if (userToken == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to send messages')),
        );
      }
      return;
    }
    setMessage("sent", _controller.text, widget.userId);
    final String message = _controller.text.trim();
    _controller.clear();
    try {
      await ref.read(sendMessageProvider((
        userToken: userToken,
        conversationId: widget.conversationId,
        message: message,
      )).future);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void getMessageHistory() async {
    final messagesette = await ref.read(conversationMessagesProvider((
      userToken: widget.userToken,
      conversationId: widget.conversationId,
    )).future);

    if (mounted) {
      setState(() {
        messages.addAll(messagesette);
      });
    }
  }

  @override
  void dispose() {
    focusNode.unfocus();
    _controller.dispose();
    _scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void setMessage(String type, String message, String fromId) {
    final messageModel = MessageModel(
      isRead: false,
      isDelivered: true,
      senderId: widget.userId,
      conversationId: widget.conversationId,
      id: '',
      type: type,
      content: message,
      createdAt: DateTime.now(),
    );

    setState(() {
      messages.add(messageModel);
    });
  }

  void onEmojiSelected(Category? category, Emoji emoji) {
    _controller
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
  }

  void toggleEmojiPicker() {
    setState(() {
      isEmojiVisible = !isEmojiVisible;
      if (isEmojiVisible) {
        focusNode.unfocus();
      } else {
        focusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messageStream = ref.watch(messageStreamProvider);

    messageStream.whenData((newMessage) {
      bool messageExists = messages.any((message) =>
          message.createdAt == newMessage.createdAt &&
          message.content == newMessage.content);

      if (!messageExists) {
        setState(() {
          messages.add(newMessage);
        });
      }
    });

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.invalidate(conversationMessagesProvider);
        }
      },
      child: GestureDetector(
        onTap: () {
          if (isEmojiVisible) {
            setState(() {
              isEmojiVisible = false;
            });
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: IndividualPage.secondaryColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: IndividualPage.primaryColor.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: IndividualPage.primaryColor.withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            color: IndividualPage.primaryColor,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: IndividualPage.secondaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert,
                    color: IndividualPage.secondaryColor),
                onPressed: () {},
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[messages.length - 1 - index];
                        final isSent = message.senderId == widget.userId;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: isSent
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (!isSent) ...[
                                Container(
                                  width: 28,
                                  height: 28,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: IndividualPage.primaryColor
                                          .withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      widget.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: IndividualPage.primaryColor
                                              .withOpacity(0.1),
                                          child: Icon(
                                            Icons.person,
                                            color: IndividualPage.primaryColor,
                                            size: 16,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                              Flexible(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.75,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSent
                                        ? IndividualPage.primaryColor
                                            .withOpacity(0.1)
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(20),
                                      topRight: const Radius.circular(20),
                                      bottomLeft:
                                          Radius.circular(isSent ? 20 : 0),
                                      bottomRight:
                                          Radius.circular(isSent ? 0 : 20),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.content,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isSent
                                              ? IndividualPage.secondaryColor
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _formatTime(message.createdAt),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          if (isSent) ...[
                                            const SizedBox(width: 4),
                                            Icon(
                                              message.isRead
                                                  ? Icons.done_all
                                                  : Icons.done,
                                              size: 14,
                                              color: message.isRead
                                                  ? Colors.blue
                                                  : Colors.grey[600],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          12,
                          16,
                          12 +
                              (isEmojiVisible
                                  ? 0
                                  : MediaQuery.of(context).padding.bottom),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        isEmojiVisible
                                            ? Icons.keyboard
                                            : Icons.emoji_emotions_outlined,
                                        color: isEmojiVisible
                                            ? IndividualPage.primaryColor
                                            : Colors.grey[600],
                                      ),
                                      onPressed: toggleEmojiPicker,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _controller,
                                        focusNode: focusNode,
                                        maxLines: null,
                                        decoration: const InputDecoration(
                                          hintText: 'Type a message...',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: const BoxDecoration(
                                color: IndividualPage.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon:
                                    const Icon(Icons.send, color: Colors.white),
                                onPressed: _sendMessage,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isEmojiVisible)
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: EmojiPicker(
                              onEmojiSelected: (category, emoji) {
                                onEmojiSelected(category, emoji);
                              },
                              onBackspacePressed: () {
                                if (_controller.text.isNotEmpty) {
                                  _controller
                                    ..text = _controller.text.characters
                                        .skipLast(1)
                                        .toString()
                                    ..selection = TextSelection.fromPosition(
                                      TextPosition(
                                          offset: _controller.text.length),
                                    );
                                }
                              },
                              textEditingController: _controller,
                              config: Config(
                                height: 250,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}
