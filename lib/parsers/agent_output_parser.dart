import 'dart:convert';

import '../models/agent_output.dart';

class AgentOutputParser {
  AgentOutput parse(String rawText) {
    try {
      final cleaned = _extractJsonObject(rawText);
      final json = jsonDecode(cleaned) as Map<String, dynamic>;

      final type = json['type'];

      if (type == 'tool_call') {
        final toolName = json['toolName'];

        if (toolName == null || toolName is! String) {
          return FinalAnswerOutput(
            answer: 'The model returned a tool call without a valid tool name.',
          );
        }

        return ToolCallOutput(
          toolName: toolName,
          arguments: Map<String, dynamic>.from(json['arguments'] ?? {}),
        );
      }

      if (type == 'final_answer') {
        return FinalAnswerOutput(
          answer: json['answer']?.toString() ?? '',
        );
      }

      return FinalAnswerOutput(
        answer: 'Invalid agent response type: $type',
      );
    } catch (e) {
      return FinalAnswerOutput(
        answer: 'I could not parse the model response as JSON. Raw response: $rawText',
      );
    }
  }

  String _extractJsonObject(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');

    if (start == -1 || end == -1 || end <= start) {
      throw FormatException('No JSON object found.');
    }

    return text.substring(start, end + 1);
  }
}