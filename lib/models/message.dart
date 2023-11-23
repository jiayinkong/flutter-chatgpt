import 'package:floor/floor.dart';

@entity // 表示这是个持久化的数据类
class Message {
  @primaryKey
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  Message({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}

// extension 在不修改原始类或创建子类的情况下向现有类添加方法的方式
extension MessageExtension on Message {
  Message copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}