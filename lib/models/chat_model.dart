class ChatModel {
  final String name;
  final String message;
  final String time;
  final String avatar;
  final int unread;
  final bool pinned;

  const ChatModel({
    required this.name,
    required this.message,
    required this.time,
    required this.avatar,
    this.unread = 0,
    this.pinned = false,
  });
}
