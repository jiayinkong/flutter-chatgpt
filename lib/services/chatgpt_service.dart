import 'package:chargpt/env.dart';
import 'package:openai_api/openai_api.dart';

class ChatGPTService {
  final client = OpenaiClient(
    config: OpenaiConfig(
      apiKey: Env.apiKey,
      baseUrl: Env.baseUrl,
      httpProxy: Env.httpProxy,
    )
  );

  // 发送请求
  Future<ChatCompletionResponse> sendChat(String content) async {
    final request = ChatCompletionRequest(
      model: Model.gpt3_5Turbo,
      messages: [
        ChatMessage(
          role: ChatMessageRole.user,
          content: content,
        ),
      ]
    );

    return await client.sendChatCompletion(request);
  }
}