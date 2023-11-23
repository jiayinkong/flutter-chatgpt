import 'package:openai_api/openai_api.dart';

import '../env.dart';

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

  Future streamChat(String content, {
    Function(String text)? onSuccess,
  }) async {
    final request = ChatCompletionRequest(
        model: Model.gpt3_5Turbo,
        stream: true,
        messages: [
          ChatMessage(role: ChatMessageRole.user, content: content)
        ]
    );

    return await client.sendChatCompletionStream(
        request,
        onSuccess: (p0) {
          final text = p0.choices.first.delta?.content;
          if(text != null) {
            onSuccess?.call(text);
          }
      },
    );
  }
}