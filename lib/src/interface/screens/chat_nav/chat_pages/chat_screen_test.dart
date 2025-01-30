import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pravasitax_flutter/src/core/theme/app_theme.dart';
import 'package:pravasitax_flutter/src/data/models/chat_model.dart';
import 'package:pravasitax_flutter/src/data/providers/chat_provider.dart';
import 'package:pravasitax_flutter/src/data/services/secure_storage_service.dart';
import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_pages/chat_info.dart';

class IndividualPage extends ConsumerStatefulWidget {
  IndividualPage(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.conversationId,
      required this.userId,
      required this.userToken});
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
  FocusNode focusNode = FocusNode();
  List<MessageModel> messages = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getMessageHistory();
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
          SnackBar(content: Text('Failed to send message: $e')),
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

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFFCFCFC),
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: AppBar(
                  elevation: 1,
                  shadowColor: Colors.white,
                  backgroundColor: AppPalette.kPrimaryColor.withOpacity(.47),
                  leadingWidth: 90,
                  titleSpacing: 0,
                  leading: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 24,
                        ),
                      ),
                      ClipOval(
                        child: Container(
                          width: 30,
                          height: 30,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return SvgPicture.asset(
                                  'assets/icons/dummy_person_small.svg');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ChatInfo(
                      //       conversationId: widget.conversationId,
                      //       title: widget.title,
                      //       imageUrl: widget.imageUrl,
                      //     ),
                      //   ),
                      // );
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          ' ${widget.title ?? ''}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                )),
            body: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: PopScope(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 10),
                            child: ListView.builder(
                              reverse: true,
                              controller: _scrollController,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[messages.length -
                                    1 -
                                    index]; // Reverse the index to get the latest message first
                                final isSent =
                                    message.senderId == widget.userId;
                                return Align(
                                  alignment: isSent
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSent
                                          ? Colors.amber.shade100
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                        bottomLeft: isSent
                                            ? Radius.circular(12)
                                            : Radius.circular(4),
                                        bottomRight: isSent
                                            ? Radius.circular(4)
                                            : Radius.circular(12),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: isSent
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          message.content,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _formatTime(message.createdAt),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        isBlocked
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF004797),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(4, 4),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'This user is blocked',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                      shadows: [
                                        // Shadow(
                                        //   color: Colors.black45,
                                        //   blurRadius: 5,
                                        //   offset: Offset(2, 2),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 5.0),
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Card(
                                          elevation: 1,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 220, 215, 215),
                                              width: 0.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 5.0),
                                            child: Container(
                                              constraints: const BoxConstraints(
                                                maxHeight:
                                                    150, // Limit the height
                                              ),
                                              child: Scrollbar(
                                                thumbVisibility: true,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  reverse:
                                                      true, // Start from bottom
                                                  child: TextField(
                                                    controller: _controller,
                                                    focusNode: focusNode,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    maxLines:
                                                        null, // Allows for unlimited lines
                                                    minLines:
                                                        1, // Starts with a single line
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText:
                                                          "Type a message",
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 2,
                                          left: 2,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppPalette.kPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.send,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              _sendMessage();
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                      ],
                    ),
                    onPopInvoked: (didPop) {
                      if (didPop) {
                        if (show) {
                          setState(() {
                            show = false;
                          });
                        } else {
                          focusNode.unfocus();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              size: 29,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
