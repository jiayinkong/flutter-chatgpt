
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/message.dart';
import '../models/session.dart';
import '../services/injection.dart';
import '../states/chat_ui_state.dart';
import '../states/message_state.dart';
import '../states/session_state.dart';

class UserInputWidget extends HookConsumerWidget {
  const UserInputWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatUiState = ref.watch(chatUiStateProvider);
    final textController = TextEditingController();

    return TextField(
      enabled: !chatUiState.requestLoading, // 处于请求未响应状态，输入框静止
      controller: textController,
      decoration: InputDecoration(
          hintText: 'Type a message', // 显示在输入框的提示文字
          suffixIcon: IconButton(
            onPressed: () {
              // 发送用户消息
              if(textController.text.isNotEmpty) {
                _sentMessage(ref, textController);
              }
            },
            icon: const Icon(Icons.send),
          )
      ),
    );
  }

  _sentMessage(WidgetRef ref, TextEditingController controller) async {
    final content = controller.text;

    // 如果是新建会话，这时我们发送的聊天消息应该存储在一个新的会话中
    // 在存储消息前，先创建一个session，然后获取 sessionId，然后将其复制给新建的消息
    // 这样来实现消息和会话的绑定
    Message message = _createMessage(content);

    var active = ref.watch(activeSessionProvider);
    var sessionId = active?.id ?? 0;
    if(sessionId <= 0) {
      active = Session(title: content);
      active = await ref.read(sessionStateNotifierProvider.notifier).upsertSession(active);
      sessionId = active.id!;
      ref.read(sessionStateNotifierProvider.notifier).setActiveSession(active.copyWith(id: sessionId));
    }

    // 添加消息
    ref.read(messageProvider.notifier).upsertMessage(message.copyWith(sessionId: sessionId));
    controller.clear();
    // gpt 回答
    _requestChatGPT(ref, content, sessionId: sessionId);
  }

  Message _createMessage(String content, {
    String? id,
    bool isUser = true,
    int? sessionId,
  }) {
    final message = Message(
      id: id ?? uuid.v4(),
      content: content,
      isUser: isUser,
      timestamp: DateTime.now(),
      sessionId: sessionId ?? 0,
    );

    return message;
  }

  _requestChatGPT(WidgetRef ref, String content, {
    int? sessionId,
  }) async {
    ref.read(chatUiStateProvider.notifier).setRequestLoading(true);
    try {
      final id = uuid.v4();
      // 使 gpt 的消息以流的形式响应回来
      await chatgpt.streamChat(
          content,
          onSuccess: (text) {
            // final message = Message(
            //   id: id,
            //   content: text,
            //   timestamp: DateTime.now(),
            //   isUser: false,
            // );

            final message = _createMessage(text, id: id, isUser: false, sessionId: sessionId);

            ref.read(messageProvider.notifier).upsertMessage(message);
          }
      );
    } catch(err) {
      logger.e('requestChatGPT error: $err', error: err);
    } finally {
      ref.read(chatUiStateProvider.notifier).setRequestLoading(false);
    }
  }
}

