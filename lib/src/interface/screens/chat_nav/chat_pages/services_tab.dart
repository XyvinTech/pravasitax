import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravasitax_flutter/src/data/providers/chat_provider.dart';
import 'package:pravasitax_flutter/src/data/services/secure_storage_service.dart';
import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_pages/chat_screen.dart';
import 'package:pravasitax_flutter/src/interface/screens/chat_nav/chat_pages/chat_screen_test.dart';
import 'package:pravasitax_flutter/src/interface/widgets/loading_indicator.dart';
class ServicesTab extends ConsumerWidget {
  const ServicesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<String?>(
      future: SecureStorageService.getAuthToken(),
      builder: (context, tokenSnapshot) {
        if (!tokenSnapshot.hasData) {
          return const Center(child: Text('Please login to view services'));
        }

        final userToken = tokenSnapshot.data!;
        final conversationsAsync = ref.watch(conversationsProvider(userToken));

        return conversationsAsync.when(
          loading: () => const Center(child: LoadingIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (conversations) {
            final serviceConversations = conversations
                .where((conv) => conv.type != 'Sales')
                .toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            if (serviceConversations.isEmpty) {
              return const Center(child: Text('No services found'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: serviceConversations.length,
              itemBuilder: (context, index) {
                final conversation = serviceConversations[index];
                final staff = conversation.staffs.isNotEmpty
                    ? conversation.staffs.first
                    : null;

                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 1),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: .7,
                        color: const Color.fromARGB(255, 219, 213, 213),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () async {
                        final userId = await SecureStorageService.getUserId();
                        final userToken =
                            await SecureStorageService.getAuthToken();
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
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              staff?.avatar ??
                                  'https://pravasitax.com/assets/images/logo.png',
                            ),
                            child: staff == null
                                ? const Icon(Icons.receipt_long, size: 28)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  conversation.title,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text('Service ID: ${conversation.id}'),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(conversation.createdAt),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: conversation.status == 1
                                  ? Colors.amber.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              conversation.statusText,
                              style: TextStyle(
                                color: conversation.status == 1
                                    ? Colors.amber
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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
