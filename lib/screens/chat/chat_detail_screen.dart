import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/chat_message.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_decorations.dart';
import '../../utils/app_routes.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/empty_state.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = ModalRoute.of(context)!.settings.arguments as String;
      final auth = context.read<AuthProvider>();
      if (auth.user != null) {
        context.read<ChatProvider>().markAsRead(id, auth.user!.id);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send(String conversationId) {
    final auth = context.read<AuthProvider>();
    final chat = context.read<ChatProvider>();

    final error = chat.sendMessage(
      conversationId,
      _controller.text,
      auth.user,
      isRegistered: auth.isRegisteredUser,
    );

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
      return;
    }

    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final conversationId = ModalRoute.of(context)!.settings.arguments as String;
    final chat = context.watch<ChatProvider>();
    final auth = context.watch<AuthProvider>();
    final conv = chat.getConversation(conversationId);
    final messages = chat.messagesFor(conversationId);
    final currentUser = auth.user;
    final canSend = currentUser != null && auth.isRegisteredUser(currentUser);
    final isMember =
        conv != null &&
        currentUser != null &&
        conv.includesUser(currentUser.id);

    if (conv == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Conversation not found')),
      );
    }

    if (!isMember) {
      return Scaffold(
        appBar: AppBar(title: Text(conv.name)),
        body: EmptyState(
          icon: Icons.lock_outline,
          title: 'Not a member',
          message: conv.type == ChatType.community
              ? 'Join the community hub to access its chat channel.'
              : 'Only registered members of this chat can view messages.',
          actionLabel: conv.type == ChatType.community &&
                  conv.communityId != null
              ? 'View community'
              : null,
          onAction: conv.type == ChatType.community &&
                  conv.communityId != null
              ? () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.communityDetails,
                    arguments: conv.communityId,
                  )
              : null,
        ),
      );
    }

    final members = chat.memberProfiles(conv, auth.allRegisteredUsers);
    final currentUserId = currentUser.id;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (conv.type == ChatType.community) ...[
              const Icon(Icons.hub_outlined, size: 18),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(conv.name),
                  Text(
                    conv.type == ChatType.community
                        ? 'Community channel · ${conv.memberCount} members'
                        : conv.type == ChatType.direct
                            ? 'Direct message'
                            : '${conv.memberCount} members',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (conv.type == ChatType.community)
            IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              tooltip: 'View community',
              onPressed: () {
                if (conv.communityId != null) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.communityDetails,
                    arguments: conv.communityId,
                  );
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          if ((conv.type == ChatType.group || conv.type == ChatType.community) &&
              members.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
              child: Text(
                conv.type == ChatType.community
                    ? members.map((m) => m.name).join(', ')
                    : 'Members: ${members.map((m) => m.name).join(', ')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          Expanded(
            child: messages.isEmpty
                ? const EmptyState(
                    icon: Icons.chat_outlined,
                    title: 'No messages yet',
                    message:
                        'Send the first message to start the conversation.',
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: messages.length,
                    itemBuilder: (_, i) => ChatBubble(
                      message: messages[i],
                      currentUserId: currentUserId,
                    ),
                  ),
          ),
          if (!canSend)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.error.withValues(alpha: 0.1),
              child: Text(
                'Log in with a registered account to send messages.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: canSend && isMember,
                      decoration: InputDecoration(
                        hintText: canSend
                            ? 'Type a message...'
                            : 'Sign in to send messages',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      onSubmitted: canSend && isMember
                          ? (_) => _send(conversationId)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppDecorations.primaryGradient(
                        isDark: Theme.of(context).brightness == Brightness.dark,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: FloatingActionButton.small(
                      onPressed: canSend && isMember
                          ? () => _send(conversationId)
                          : null,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
