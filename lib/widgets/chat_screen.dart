import '/states/session_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'chat_input.dart';
import 'chat_message_list.dart';

class ChatScreen extends HookConsumerWidget {

  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF1F1F1),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 24),
              // 消息列表
              Expanded(
                child: ChatMessageList(),
              ),

              // 聊天输入框
              UserInputWidget(),
              SizedBox(height: 24,)
            ],
          ),
        ),
      ),
    );
  }
}