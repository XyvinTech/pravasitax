// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pravasitax_flutter/src/core/theme/app_theme.dart';
// import 'package:pravasitax_flutter/src/data/providers/chat_provider.dart';
// import 'package:pravasitax_flutter/src/data/services/secure_storage_service.dart';
// import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_pages/chat_info.dart';

// class UserChatScreen extends ConsumerStatefulWidget {
//   final String title;
//   final String imageUrl;
//   final String conversationId;
//   final String userId;
//   final String userToken;
//   const UserChatScreen( {
//     required this.userToken,
//     required this.userId,
//     super.key,
//     required this.title,
//     required this.imageUrl,
//     required this.conversationId,
//   });

//   @override
//   ConsumerState<UserChatScreen> createState() => _UserChatScreenState();
// }

// class _UserChatScreenState extends ConsumerState<UserChatScreen> {
//   final TextEditingController _controller = TextEditingController();

//   Future<void> _sendMessage() async {
//     if (_controller.text.trim().isEmpty) return;

//     final userToken = await SecureStorageService.getAuthToken();
//     if (userToken == null) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please login to send messages')),
//         );
//       }
//       return;
//     }

//     try {
//       await ref.read(sendMessageProvider((
//         userToken: userToken,
//         conversationId: widget.conversationId,
//         message: _controller.text.trim(),
//       )).future);

//       _controller.clear();
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to send message: $e')),
//         );
//       }
//     }
//   }

//   late final webSocketClient;

//   @override
//   void initState() {
//     super.initState();
//     webSocketClient = ref.read(socketProvider);
//     webSocketClient.connect();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, ref, child) {
//         final newMessages = ref.watch(newMessageProvider(widget.userId));
//         return Scaffold(
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//             backgroundColor: const Color(0xFFFFCD29).withOpacity(.47),
//             titleSpacing: 0,
//             title: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 CircleAvatar(
//                   backgroundImage: NetworkImage(widget.imageUrl),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ChatInfo(
//                             conversationId: widget.conversationId,
//                             title: widget.title,
//                             imageUrl: widget.imageUrl,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       widget.title,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.phone, color: Colors.black),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//           body: Column(
//             children: [
//               Expanded(
//                   child: newMessages.when(
//                 loading: () => const Center(child: LoadingIndicator()),
//                 error: (error, stack) {
//                   debugPrint('Error loading messages: $error');
//                   return Center(child: Text('Error: $error'));
//                 },
//                 data: (messages) {
//                   final messagesAsync = ref.watch(conversationMessagesProvider((
//                     userToken: widget.userToken,
//                     conversationId: widget.conversationId,
//                   )));

//                   messagesAsync.whenData(
//                     (oldMessages) {
//                       messages.addAll(oldMessages);
//                     },
//                   );
//                   debugPrint('Received messages: $messages');
//                   if (messages.isEmpty) {
//                     return const Center(child: Text('No messages yet'));
//                   }

//                   return ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: messages.length,
//                     itemBuilder: (context, index) {
//                       final message = messages[index];
//                       debugPrint('Rendering message: ${message.content}');
//                       final isSent = message.senderId == widget.userId;

//                       return Align(
//                         alignment: isSent
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(vertical: 4),
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: isSent
//                                 ? Colors.amber.shade100
//                                 : Colors.grey.shade200,
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(12),
//                               topRight: Radius.circular(12),
//                               bottomLeft: isSent
//                                   ? Radius.circular(12)
//                                   : Radius.circular(4),
//                               bottomRight: isSent
//                                   ? Radius.circular(4)
//                                   : Radius.circular(12),
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: isSent
//                                 ? CrossAxisAlignment.end
//                                 : CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 message.content,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 _formatTime(message.createdAt),
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               )),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 8,
//                       offset: const Offset(0, -2),
//                     ),
//                   ],
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: Container(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(width: .5, color: Colors.grey),
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 8.0),
//                                   child: TextField(
//                                     controller: _controller,
//                                     decoration: const InputDecoration(
//                                       hintStyle: TextStyle(
//                                         color:
//                                             Color.fromARGB(255, 234, 224, 224),
//                                       ),
//                                       hintText: "Type your message here",
//                                       border: InputBorder.none,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.attach_file,
//                                     color: Colors.grey),
//                                 onPressed: () {},
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       SizedBox(
//                         width: 55,
//                         height: 55,
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             color: AppPalette.kPrimaryColor,
//                             borderRadius: BorderRadius.all(Radius.circular(10)),
//                           ),
//                           padding: const EdgeInsets.all(8),
//                           child: IconButton(
//                             icon: const Icon(Icons.send_outlined,
//                                 color: Colors.black),
//                             onPressed: _sendMessage,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   String _formatTime(DateTime dateTime) {
//     final now = DateTime.now();
//     final difference = now.difference(dateTime);

//     if (difference.inMinutes < 60) {
//       return '${difference.inMinutes}m ago';
//     } else if (difference.inHours < 24) {
//       return '${difference.inHours}h ago';
//     } else {
//       return '${difference.inDays}d ago';
//     }
//   }
// }
