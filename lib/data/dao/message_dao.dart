
import '/models/message.dart';
import 'package:floor/floor.dart';

@dao // 创建数据访问对象
abstract class MessageDao {
  @Query('SELECT * FROM Message')
  Future<List<Message>> findAllMessages();

  @Query('SELECT * FROM Message WHERE id = :id')
  Future<Message?> findMessageById(String id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertMessage(Message message);

  @delete
  Future<void> deleteMessage(Message message);

  // 通过回话 id 来查询所有的消息
  @Query('SELECT * FROM Message WHERE session_id = :sessionId')
  Future<List<Message>> findMessagesBySessionId(int sessionId);
}