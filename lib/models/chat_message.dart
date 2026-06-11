enum ChatType { direct, group, community }

class ChatConversation {
  ChatConversation({
    required this.id,
    required this.name,
    required this.type,
    required this.avatarUrl,
    required this.memberIds,
    required this.createdById,
    this.communityId,
    this.lastMessage = '',
    this.lastMessageTime,
    this.unreadCount = 0,
  });

  final String id;
  final String name;
  final ChatType type;
  final String avatarUrl;
  final List<String> memberIds;
  final String createdById;
  final String? communityId;
  String lastMessage;
  DateTime? lastMessageTime;
  int unreadCount;

  int get memberCount => memberIds.length;

  bool includesUser(String userId) => memberIds.contains(userId);
}

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    this.attachmentName,
    this.attachmentType,
  });

  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final String? attachmentName;
  final String? attachmentType;
}
