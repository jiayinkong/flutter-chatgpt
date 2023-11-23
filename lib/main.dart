import 'data/database.dart';
import '/services/injection.dart';
import '/widgets/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/**
 * 要获取数据库的实例，需要使用生成的 $FloorAppDatabase 类，它允许访问数据库构建器，名称由 $floor 和数据库类名组成
 * 传递给 databaseBuilder() 的字符串是 app_database 数据库文件名
 * 要初始化数据库，需要调用 build 并确保等待结果，使用 async await
 */
///

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChatScreen(),
    );
  }
}
