import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravasitax_flutter/src/data/providers/chat_provider.dart';
import 'package:pravasitax_flutter/src/data/services/secure_storage_service.dart';
import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_pages/chat_screen.dart';
import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_pages/chat_screen_test.dart';
import 'package:pravasitax_flutter/src/interface/widgets/loading_indicator.dart';

class EnquiriesTab extends ConsumerWidget {
  const EnquiriesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<String?>(
      future: SecureStorageService.getAuthToken(),
      builder: (context, tokenSnapshot) {
        if (!tokenSnapshot.hasData) {
          return const Center(child: Text('Please login to view enquiries'));
        }

        final userToken = tokenSnapshot.data!;
        final conversationsAsync = ref.watch(conversationsProvider(userToken));

        return conversationsAsync.when(
          loading: () => const Center(child: LoadingIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (conversations) {
            final enquiryConversations = conversations
                .where((conv) => conv.type == 'Sales')
                .toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            if (enquiryConversations.isEmpty) {
              return const Center(child: Text('No enquiries found'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: enquiryConversations.length,
              itemBuilder: (context, index) {
                final conversation = enquiryConversations[index];
                final staff = conversation.staffs.isNotEmpty
                    ? conversation.staffs.first
                    : null;

                return GestureDetector(
                  onTap: () async {
                    final userId = await SecureStorageService.getUserId();
                    final userToken = await SecureStorageService.getAuthToken();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualPage(
                          userId: userId ?? '',
                          userToken: userToken ?? '',
                          title: conversation.title,
                          imageUrl: staff?.avatar ??
                              'https://pravasitax.com/assets/images/logo.png',
                          conversationId: conversation.id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: .7,
                        color: const Color.fromARGB(255, 219, 213, 213),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            staff?.avatar ??
                                'https://pravasitax.com/assets/images/logo.png',
                          ),
                          radius: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                conversation.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                conversation.createdAt,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (conversation.unreadMessages > 0)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              conversation.unreadMessages.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
