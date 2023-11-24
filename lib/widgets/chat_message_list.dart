import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:markdown_widget/config/markdown_generator.dart';

import '../markdown/latex.dart';
import '../models/message.dart';
import '../states/message_state.dart';

class ChatMessageList extends HookConsumerWidget {
  const ChatMessageList({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(activeSessionMessagesProvider);
    final listController = useScrollController(); // 使用 flutter_hooks 库

    ref.listen(activeSessionMessagesProvider, (previous, next) {
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
