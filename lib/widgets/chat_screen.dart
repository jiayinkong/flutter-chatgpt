import 'package:chargpt/services/injection.dart';
import 'package:chargpt/states/chat_ui_state.dart';
import 'package:chargpt/states/message_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/message.dart';

class ChatScreen extends HookConsumerWidget {
  // final List<Message> messages = [
  //   Message(content: 'hello', isUser: true, timestamp: DateTime.now()),
  //   Message(content: 'How are you ?', isUser: false, timestamp: DateTime.now()),
  //   Message(content: 'Fine, thank you, and you ?', isUser: true, timestamp: DateTime.now()),
  //   Message(content: 'I am fine.', isUser: false, timestamp: DateTime.now()),
  // ];

  final _textController = TextEditingController();

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messageProvider); // 获取数据
    final chatUiState = ref.watch(chatUiStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // 消息列表
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return MessageItem(message: messages[index]);
                },
                itemCount: messages.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 16,
                ),
              ),
            ),

            // 聊天输入框
            TextField(
              enabled: !chatUiState.requestLoading, // 处于请求未响应状态，输入框静止
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type a message', // 显示在输入框的提示文字
                suffixIcon: IconButton(
                  onPressed: () {
                    if(_textController.text.isNotEmpty) {
                      _sentMessage(ref, _textController.text);
                    }
                  },
                  icon: const Icon(Icons.send),
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  _sentMessage(WidgetRef ref, String content) {
    final message = Message(
      id: uuid.v4(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // 添加用户的提问消息
    ref.read(messageProvider.notifier).upsertMessage(message);
    _textController.clear();

    // 添加 gpt 的回答消息
    _requestChatGPT(ref, content);
  }

  _requestChatGPT(WidgetRef ref, String content) async {
    ref.read(chatUiStateProvider.notifier).setRequestLoading(true);

    try {
      // final res = await chatgpt.sendChat(content);
      // ref.read(chatUiStateProvider.notifier).setRequestLoading(false);
      //
      // final text = res.choices.first.message?.content ?? '';
      // final message = Message(
      //   id: uuid.v4(),
      //   content: text,
      //   isUser: false,
      //   timestamp: DateTime.now(),
      // );
      //
      // // 把 gpt 的 message 添加到 messages 消息列表
      // ref.read(messageProvider.notifier).upsertMessage(message);


      // gpt 的消息以流的形式响应回来
      final id = uuid.v4();
      await chatgpt.streamChat(
        content,
        onSuccess: (text) {
          final message = Message(
            id: id,
            content: text,
            timestamp: DateTime.now(),
            isUser: false,
          );

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

class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: message.isUser ?
          Colors.blue : Colors.grey,
          child: Text(
            message.isUser ? 'A' : 'GPT'
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Flexible(
            child: Container(
                margin: const EdgeInsets.only(top: 12),
                child: Text(message.content)
            )
        ),
      ],
    );
  }
}


