import 'package:go_router/go_router.dart';

import '/widgets/chat_history.dart';
import '/widgets/chat_screen.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const ChatScreen(),
  ),
  GoRoute(
    path: '/history',
    builder: (context, state) => const ChatHistory(),
  )
]);