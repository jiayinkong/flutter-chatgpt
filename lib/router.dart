import 'package:chargpt/utils.dart';
import 'package:chargpt/widgets/home_screen.dart';
import 'package:go_router/go_router.dart';

import '/widgets/chat_history.dart';

final router = isDesktop() ? desktopRouter : mobileRouter;

final mobileRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const HomeScreen(),
  ),
  // GoRoute(
  //   path: '/history',
  //   builder: (context, state) => const ChatHistory(),
  // )
]);

final desktopRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const DesktopHomeScreen(),
  )
]);