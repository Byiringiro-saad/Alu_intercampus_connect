import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/chat_message.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_decorations.dart';
import '../../utils/app_routes.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/profile_avatar.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final auth = context.watch<AuthProvider>();
    final currentUser = auth.user;
    final conversations = currentUser == null
        ? <ChatConversation>[]
        : chat.conversationsForUser(currentUser.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.brand(isDark);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Messages',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontSize: 28,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Connect with registered students on your campus',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: currentUser == null
                      ? null
                      : () => Navigator.pushNamed(context, AppRoutes.newChat),
                  icon: const Icon(Icons.edit_square),
                ),
                IconButton(
                  onPressed: currentUser == null
                      ? null
                      : () =>
                          Navigator.pushNamed(context, AppRoutes.createGroup),
                  icon: const Icon(Icons.group_add_outlined),
                ),
              ],
            ),
          ),
        ),
        if (conversations.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(
              icon: Icons.forum_outlined,
              title: 'No conversations yet',
              message: 'Start a direct message or join a community hub to chat with classmates.',
              actionLabel: currentUser == null ? null : 'New message',
              onAction: currentUser == null
                  ? null
                  : () => Navigator.pushNamed(context, AppRoutes.newChat),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 110),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final conv = conversations[i];
                  final time = conv.lastMessageTime != null
                      ? DateFormat('h:mm a').format(conv.lastMessageTime!)
                      : '';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.chatDetail,
                          arguments: conv.id,
                        ),
                        borderRadius:
                            BorderRadius.circular(AppDecorations.radiusLg),
                        child: Ink(
                          padding: const EdgeInsets.all(14),
                          decoration: AppDecorations.surfaceCard(context),
                          child: Row(
                            children: [
                              conv.type == ChatType.community
                                  ? CircleAvatar(
                                      radius: 26,
                                      backgroundColor:
                                          accent.withValues(alpha: 0.12),
                                      child: Icon(
                                        Icons.hub_outlined,
                                        color: accent,
                                      ),
                                    )
                                  : conv.type == ChatType.group
                                      ? CircleAvatar(
                                          radius: 26,
                                          backgroundColor:
                                              accent.withValues(alpha: 0.12),
                                          child: Icon(
                                            Icons.groups_rounded,
                                            color: accent,
                                          ),
                                        )
                                      : ProfileAvatar(
                                          avatarUrl: conv.avatarUrl,
                                          radius: 26,
                                        ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      conv.name,
                                      style: TextStyle(
                                        fontWeight: conv.unreadCount > 0
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      conv.lastMessage.isEmpty
                                          ? conv.type == ChatType.group
                                              ? '${conv.memberCount} members'
                                              : 'Say hello'
                                          : conv.lastMessage,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              if (time.isNotEmpty)
                                Text(
                                  time,
                                  style:
                                      Theme.of(context).textTheme.labelSmall,
                                ),
                              if (conv.unreadCount > 0) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${conv.unreadCount}',
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.darkBackground
                                          : Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: conversations.length,
              ),
            ),
          ),
      ],
    );
  }
}
