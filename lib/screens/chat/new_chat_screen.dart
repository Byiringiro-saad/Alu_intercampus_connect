import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/profile_avatar.dart';

class NewChatScreen extends StatelessWidget {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final chat = context.read<ChatProvider>();
    final currentUser = auth.user;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('New Message')),
        body: const Center(child: Text('Please log in first')),
      );
    }

    final others = auth.otherRegisteredUsers(currentUser.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Message'),
        actions: [
          TextButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.createGroup),
            icon: const Icon(Icons.group_add_outlined),
            label: const Text('Group'),
          ),
        ],
      ),
      body: others.isEmpty
          ? const EmptyState(
              icon: Icons.person_add_outlined,
              title: 'No other students yet',
              message:
                  'Sign up with another email in a new session to chat between accounts.',
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: others.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final user = others[index];
                return ListTile(
                  leading: ProfileAvatar(avatarUrl: user.avatarUrl),
                  title: Text(user.name),
                  subtitle: Text('${user.program} · ${user.campus}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    final conversationId = chat.startDirectChat(
                      currentUser,
                      user,
                      isRegistered: auth.isRegisteredUser,
                    );

                    if (conversationId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not start conversation'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }

                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.chatDetail,
                      arguments: conversationId,
                    );
                  },
                );
              },
            ),
    );
  }
}
