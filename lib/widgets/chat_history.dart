import 'package:chargpt/models/session.dart';

import '/states/session_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatHistory extends HookConsumerWidget {
  const ChatHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Center(
        // AsyncValue提供了一个when函数，对于不同的状态提供了不同的函数来加载页面
        child: state.when(
          data: (state) {
            return ListView(
              children: [
                for(var i in state.sessionList)
                  ListTile(
                    title: Row(
                      children: [
                        Expanded(child: Text(i.title)),
                        IconButton(
                          onPressed: () {
                            _deleteConfirm(context, ref, i);
                          },
                          icon: const Icon(Icons.delete),
                        )
                      ],
                    ),
                    onTap: () {
                      ref.read(sessionStateNotifierProvider.notifier).setActiveSession(i);
                      GoRouter.of(context).pop();
                    },
                    selected: state.activeSession?.id == i.id,
                  )
              ],
            );
          },
          error: (Object error, StackTrace stackTrace) => Text('$error'),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }

  void _deleteConfirm(BuildContext context, WidgetRef ref, Session session) async {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure to delete?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(sessionStateNotifierProvider.notifier).deleteSession(session);
            },
            child: const Text('Delete'),
          )
        ],
      );
    });
  }
}
