import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../models/user_profile.dart';

/// ChatProvider — user-to-user messaging between registered accounts only.
class ChatProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  final List<ChatConversation> _conversations = [];
  final Map<String, List<ChatMessage>> _messages = {};

  Future<void> init() async {
    notifyListeners();
  }

  List<ChatConversation> conversationsForUser(String userId) {
    final list =
        _conversations.where((conv) => conv.includesUser(userId)).toList();
    list.sort((a, b) {
      final aTime = a.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    return list;
  }

  int totalUnreadForUser(String userId) => conversationsForUser(userId)
      .fold(0, (sum, conv) => sum + conv.unreadCount);

  List<ChatMessage> messagesFor(String conversationId) =>
      _messages[conversationId] ?? [];

  ChatConversation? getConversation(String id) {
    try {
      return _conversations.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  String _directConversationId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return 'dm-${ids[0]}-${ids[1]}';
  }

  /// Opens or returns an existing direct chat between two registered users.
  String? startDirectChat(
    UserProfile currentUser,
    UserProfile otherUser, {
    required bool Function(UserProfile?) isRegistered,
  }) {
    if (!isRegistered(currentUser) || !isRegistered(otherUser)) {
      return null;
    }
    if (currentUser.id == otherUser.id) {
      return null;
    }

    final conversationId = _directConversationId(currentUser.id, otherUser.id);
    if (getConversation(conversationId) != null) {
      return conversationId;
    }

    final conversation = ChatConversation(
      id: conversationId,
      name: otherUser.name,
      type: ChatType.direct,
      avatarUrl: otherUser.avatarUrl,
      memberIds: [currentUser.id, otherUser.id],
      createdById: currentUser.id,
    );

    _conversations.insert(0, conversation);
    _messages[conversationId] = [];
    notifyListeners();
    return conversationId;
  }

  /// Creates a group chat with registered members only.
  String? createGroup({
    required String name,
    required UserProfile creator,
    required List<UserProfile> selectedMembers,
    required bool Function(UserProfile?) isRegistered,
  }) {
    if (!isRegistered(creator)) {
      return null;
    }

    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return null;
    }

    final memberIds = <String>{creator.id};
    for (final member in selectedMembers) {
      if (!isRegistered(member)) {
        return null;
      }
      memberIds.add(member.id);
    }

    if (memberIds.length < 2) {
      return null;
    }

    final conversationId = _uuid.v4();
    final conversation = ChatConversation(
      id: conversationId,
      name: trimmedName,
      type: ChatType.group,
      avatarUrl: '',
      memberIds: memberIds.toList(),
      createdById: creator.id,
      lastMessage: 'Group created',
      lastMessageTime: DateTime.now(),
    );

    _conversations.insert(0, conversation);
    _messages[conversationId] = [];
    notifyListeners();
    return conversationId;
  }

  /// Returns an error message if send failed, or null on success.
  String? sendMessage(
    String conversationId,
    String content,
    UserProfile? sender, {
    required bool Function(UserProfile?) isRegistered,
  }) {
    if (sender == null || !isRegistered(sender)) {
      return 'You must be logged in with a registered account to send messages.';
    }

    final conversation = getConversation(conversationId);
    if (conversation == null) {
      return 'Conversation not found.';
    }

    if (!conversation.includesUser(sender.id)) {
      return 'You are not a member of this conversation.';
    }

    if (content.trim().isEmpty) {
      return 'Message cannot be empty.';
    }

    final message = ChatMessage(
      id: _uuid.v4(),
      conversationId: conversationId,
      senderId: sender.id,
      senderName: sender.name,
      content: content.trim(),
      timestamp: DateTime.now(),
    );

    _messages.putIfAbsent(conversationId, () => []).add(message);
    conversation.lastMessage = content.trim();
    conversation.lastMessageTime = DateTime.now();
    notifyListeners();
    return null;
  }

  // ── Community channels ──────────────────────────────────────────────────

  static String communityChannelId(String communityId) =>
      'comm-channel-$communityId';

  /// Ensures a community channel exists and adds [userId] as a member.
  /// Safe to call multiple times — idempotent.
  void joinCommunityChannel(
    String communityId,
    String communityName,
    String userId,
    String userName,
  ) {
    final channelId = communityChannelId(communityId);
    final existing = getConversation(channelId);

    if (existing == null) {
      final conv = ChatConversation(
        id: channelId,
        name: communityName,
        type: ChatType.community,
        avatarUrl: '',
        memberIds: [userId],
        createdById: userId,
        communityId: communityId,
        lastMessage: '$userName joined the hub',
        lastMessageTime: DateTime.now(),
      );
      _conversations.insert(0, conv);
      _messages[channelId] = [];
    } else if (!existing.memberIds.contains(userId)) {
      existing.memberIds.add(userId);
      existing.lastMessage = '$userName joined the hub';
      existing.lastMessageTime = DateTime.now();
    }

    notifyListeners();
  }

  /// Removes [userId] from the community channel.
  /// Deletes the channel entirely if no members remain.
  void leaveCommunityChannel(String communityId, String userId) {
    final channelId = communityChannelId(communityId);
    final conv = getConversation(channelId);
    if (conv == null) return;

    conv.memberIds.remove(userId);

    if (conv.memberIds.isEmpty) {
      _conversations.remove(conv);
      _messages.remove(channelId);
    }

    notifyListeners();
  }

  void markAsRead(String conversationId, String userId) {
    final conversation = getConversation(conversationId);
    if (conversation != null &&
        conversation.includesUser(userId) &&
        conversation.unreadCount > 0) {
      conversation.unreadCount = 0;
      notifyListeners();
    }
  }

  List<UserProfile> memberProfiles(
    ChatConversation conversation,
    List<UserProfile> allUsers,
  ) {
    return allUsers
        .where((user) => conversation.memberIds.contains(user.id))
        .toList();
  }
}
