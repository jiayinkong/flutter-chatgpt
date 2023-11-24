import 'package:chargpt/router.dart';
import 'package:flutter_tiktoken/flutter_tiktoken.dart';

import 'data/database.dart';
import 'package:floor/floor.dart';

import 'services/injection.dart';
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
  await TiktokenDataProcessCenter().initata();
  db = await $FloorAppDatabase.databaseBuilder('app_database.db').addMigrations(
    [
      Migration(1, 2, (database) async {
        // 如果 Session 数据表未存在，则新建 Session 表
        await database.execute(
          'CREATE TABLE IF NOT EXISTS `Session` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL)'
        );
        // 给现有的数据库 Message表 增加字段 session_id
        await database.execute(
          'ALTER TABLE Message ADD COLUMN session_id INTEGER'
        );
        // 新建一条 session 数据来保存之前所有的消息
        await database.execute(
          'insert into Session (id, title) values (1, "Default")'
        );
        // 将之前的消息，全部关联到这一条 session 记录上
        await database.execute(
          'UPDATE Message SET session_id = 1 WHERE 1=1'
        );
      })
    ]
  ).build();
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      // home: ChatScreen(),
    );
  }
}
