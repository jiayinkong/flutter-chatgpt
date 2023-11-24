import 'package:chargpt/widgets/typing_cursor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:markdown_widget/config/markdown_generator.dart';

import '../markdown/latex.dart';
import '../models/message.dart';
import '../states/chat_ui_state.dart';
import '../states/message_state.dart';

class ChatMessageList extends HookConsumerWidget {
  const ChatMessageList({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(activeSessionMessagesProvider);
    final uiState = ref.watch(chatUiStateProvider);
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
        final msg = messages[index];
        return msg.isUser ?
          SentMessageItem(
            message: msg,
            backgroundColor: const Color(0xFF8FE869),
          ) :
          ReceivedMessageItem(
              message: msg,
              typing: index == messages.length - 1 && uiState.requestLoading,
          );
      },
      itemCount: messages.length,
      separatorBuilder: (context, index) => const Divider(
        height: 16,
        color: Colors.transparent,
      ),
    );
  }
}

class SentMessageItem extends StatelessWidget {
  final Color backgroundColor;
  final double radius;

  const SentMessageItem({
    super.key,
    required this.message,
    this.backgroundColor = Colors.white,
    this.radius = 8,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(radius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.only(left: 48),
            child: MessageContentWidget(
              message: message,
            ),
          ),
        ),
        CustomPaint(
          painter: Triangle(backgroundColor),
        ),
        const SizedBox(width: 8,),
        const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            'A',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

class ReceivedMessageItem extends StatelessWidget {
  final Color backgroundColor;
  final double radius;
  final bool typing;

  const ReceivedMessageItem({
    super.key,
    required this.message,
    this.backgroundColor = Colors.white,
    this.radius = 8,
    this.typing = false,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Container(
            color: Colors.transparent,
            child: SvgPicture.asset('assets/images/chatgpt.svg'),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        CustomPaint(
          painter: Triangle(backgroundColor),
        ),
        Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(radius),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.only(right: 48),
              child: MessageContentWidget(
                message: message,
                typing: typing,
              )
            )
        ),
      ],
    );
  }
}

class MessageContentWidget extends StatelessWidget {
  final Message message;
  final bool typing;

  const MessageContentWidget({
    super.key,
    required this.message,
    this.typing = false,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...MarkdownGenerator(
              generators: [
                latexGenerator,
              ],
              inlineSyntaxList: [
                LatexSyntax(),
              ],
          ).buildWidgets(message.content),
          if(typing) const TypingCursor(),
        ]
      ),
    );
  }
}

class Triangle extends CustomPainter {
  final Color bgColor;

  Triangle(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
