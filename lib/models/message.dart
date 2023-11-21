class Message {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  // 将 Map 对象转成 JSON 格式
  Map<String, dynamic> toJson() => {
    'content': content,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
  };

  // 从 JSON 数据中创建一个 Message 对象
  factory Message.fromJson(Map<String, dynamic> json) => Message(
    content: json['content'],
    isUser: json['isUser'],
    timestamp: json['timestamp'],
  );
}