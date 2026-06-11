import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat_message.dart';
import '../utils/app_colors.dart';
import '../utils/app_decorations.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  final ChatMessage message;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSent =
        currentUserId != null && message.senderId == currentUserId;
    final time = DateFormat('h:mm a').format(message.timestamp);
    final accent = AppColors.brand(isDark);

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Column(
          crossAxisAlignment:
              isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isSent)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  message.senderName,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: isSent
                    ? accent
                    : (isDark ? AppColors.darkCard : AppColors.surfaceMuted),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isSent ? 18 : 4),
                  bottomRight: Radius.circular(isSent ? 4 : 18),
                ),
                border: isSent
                    ? null
                    : Border.all(color: AppDecorations.borderColor(context)),
              ),
              child: message.attachmentName != null
                  ? _AttachmentBubble(name: message.attachmentName!, isSent: isSent)
                  : Text(
                      message.content,
                      style: TextStyle(
                        color: isSent
                            ? (isDark
                                ? AppColors.darkBackground
                                : Colors.white)
                            : null,
                        height: 1.4,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Text(time, style: Theme.of(context).textTheme.labelSmall),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentBubble extends StatelessWidget {
  const _AttachmentBubble({required this.name, required this.isSent});
  final String name;
  final bool isSent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.picture_as_pdf_rounded,
          color: isSent ? Colors.white : AppColors.error,
          size: 26,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            name,
            style: TextStyle(
              color: isSent ? Colors.white : null,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
