import '/states/session_state.dart';
import '/widgets/chat_history.dart';
import '/widgets/chat_screen.dart';
import '/widgets/desktop.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DesktopHomeScreen extends StatelessWidget {
  const DesktopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DesktopWindow(
        child: Row(
          children: [
            SizedBox(
              width: 240,
              child: Column(
                children: [
                  SizedBox(height: 24,),
                  NewChatButton(),
                  Expanded(child: ChatHistoryWindow(),),
                ],
              ),
            ),
            Expanded(child: ChatScreen())
          ],
        ),
      ),
    );
  }
}

class NewChatButton extends HookConsumerWidget {
  const NewChatButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: SizedBox(
        height: 40,
        child: OutlinedButton.icon(
          style: ButtonStyle(
            alignment: Alignment.centerLeft,
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            )),
            iconColor: MaterialStateProperty.all(Colors.black),
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
          onPressed: () {
            ref.read(sessionStateNotifierProvider.notifier).setActiveSession((null));
          },
          icon: const Icon(Icons.add, size: 16,),
          label: const Text('New chat'),
        ),
      ),
    );
  }

}

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const Drawer(
        child: ChatHistoryWindow(),
      ),
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     GoRouter.of(context).push('/history');
          //   },
          //   icon: const Icon(Icons.history),
          // ),
          IconButton(
            onPressed: () {
              ref.read(sessionStateNotifierProvider.notifier).setActiveSession(null);
            },
            icon: const Icon(Icons.add),
          ),
          // IconButton(
          //   onPressed: () {
          //     GoRouter.of(context).push('/settings');
          //   },
          //   icon: const Icon(Icons.settings),
          // )
        ],
      ),
      body: const ChatScreen(),
    );
  }
}