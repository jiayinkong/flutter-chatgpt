import 'package:chargpt/markdown/latex.dart';
import 'package:chargpt/services/injection.dart';
import 'package:chargpt/states/chat_ui_state.dart';
import 'package:chargpt/states/message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:markdown_widget/config/all.dart';

import '../models/message.dart';

class ChatScreen extends HookConsumerWidget {

  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            // 消息列表
            Expanded(
              child: ChatMessageList(),
            ),

            // 聊天输入框
            UserInputWidget(),
          ],
        ),
      ),
    );
  }
}

class ChatMessageList extends HookConsumerWidget {
  const ChatMessageList({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messageProvider); // 获取数据
    final listController = useScrollController(); // 使用 flutter_hooks 库

    ref.listen(messageProvider, (previous, next) {
      Future.delayed(const Duration(milliseconds: 50), () {
        // 消息列表内容增多时，自动滚动，让内容显示在屏幕上
        listController.jumpTo(listController.position.maxScrollExtent);
      });
    });

    return ListView.separated(
      controller: listController, // 添加列表控件以控制内容的显示
      itemBuilder: (context, index) {
        return MessageItem(message: messages[index]);
      },
      itemCount: messages.length,
      separatorBuilder: (context, index) => const Divider(
        height: 16,
      ),
    );
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
                margin: const EdgeInsets.only(right: 48),
                child: MessageContentWidget(message: message)
            )
        ),
      ],
    );
  }
}

class MessageContentWidget extends StatelessWidget {
  const MessageContentWidget({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: MarkdownGenerator(
        generators: [
          latexGenerator,
        ],
        inlineSyntaxList: [
          LatexSyntax(),
        ]
      ).buildWidgets(message.content),
    );
  }
}


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

  _sentMessage(WidgetRef ref, TextEditingController controller) {
    final content = controller.text;
    final message = Message(
      id: uuid.v4(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // 添加用户的提问消息到消息列表
    ref.read(messageProvider.notifier).upsertMessage(message);
    controller.clear(); // 清空输入框内容

    // gpt 的回答
    _requestChatGPT(ref, content);
  }

  _requestChatGPT(WidgetRef ref, String content) async {
    ref.read(chatUiStateProvider.notifier).setRequestLoading(true);
    try {
      final id = uuid.v4();
      // 使 gpt 的消息以流的形式响应回来
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

