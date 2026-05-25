import 'dart:convert';

import 'package:http/http.dart' as http;

import 'llm_client.dart';

class LlamaCppClient implements LLMClient {
  final String baseUrl;
  final String model;
  final http.Client httpClient;

  LlamaCppClient({
    required this.baseUrl,
    required this.model,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  @override
  Future<String> generate(String prompt) async {
    final uri = Uri.parse('$baseUrl/v1/chat/completions');

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {
            'role': 'system',
            'content': _systemPrompt(),
          },
          {
            'role': 'user',
            'content': prompt,
          },
        ],
        'temperature': 0,
        'max_tokens': 300,
        'stream': false,
        'response_format': {
          'type': 'json_object',
        },
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'llama.cpp request failed: ${response.statusCode} ${response.body}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    final choices = json['choices'] as List<dynamic>;
    final firstChoice = choices.first as Map<String, dynamic>;
    final message = firstChoice['message'] as Map<String, dynamic>;

    final content = message['content'];

    if (content == null || content is! String) {
      throw Exception('llama.cpp returned empty content.');
    }

    return content.trim();
  }

  String _systemPrompt() {
    return '''
You are a tool-using AI agent.

You must return valid JSON only.
Do not use markdown.
Do not wrap the JSON in code fences.
Do not explain your reasoning.

You can return only one of these two JSON shapes:

1. Tool call:
{
  "type": "tool_call",
  "toolName": "calculator",
  "arguments": {
    "expression": "10 + 5"
  }
}

2. Final answer:
{
  "type": "final_answer",
  "answer": "Your answer here"
}

Rules:
- If the user asks for a math calculation, call the calculator tool.
- If you already have a tool result, return a final_answer.
- Never invent tool results.
- Return JSON only.
''';
  }
}