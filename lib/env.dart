/// 执行以下命令在同文件夹下生成对应的 env.g.dart 文件：
/// flutter pub run build_runner build --delete-conflicting-outputs
/// 同时，同文件夹里面需要创建一个 .env 文件用来放置常量 OPENAI_API_KEY、 HTTP_PROXY 等私密信息
/// .env、env.g.dart 文件内容属于隐私内容，不应该上传到仓库中

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: 'apiKey')
  static String apiKey = _Env.apiKey;

  @EnviedField(varName: 'HTTP_PROXY')
  static String httpProxy = _Env.httpProxy;

  @EnviedField(varName: 'BASE_URL')
  static String baseUrl = _Env.baseUrl;
}
