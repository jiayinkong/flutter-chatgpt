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
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // messages.add(message);
    ref.read(messageProvider.notifier).addMessage(message); // 添加消息
    _textController.clear();
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
        Text(message.content),
      ],
    );
  }
}


