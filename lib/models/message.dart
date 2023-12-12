import 'package:floor/floor.dart';

@entity // 表示这是个持久化的数据类
class Message {
  @primaryKey
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;

  @ForeignKey(
    childColumns: ['session_id'], // 定义当前实体的列
    parentColumns: ['id'], // 定义父实体的列
    entity: Message, // 父实体类型
  )

  @ColumnInfo(name: 'session_id')
  final int? sessionId; // 外键

  Message({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.sessionId,
  });
}

// extension 在不修改原始类或创建子类的情况下向现有类添加方法的方式
extension MessageExtension on Message {
  Message copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    int? sessionId,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}