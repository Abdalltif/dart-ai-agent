import 'dart:convert';

import '../models/agent_output.dart';

class AgentOutputParser {
  AgentOutput parse(String rawText) {
    try {
      final json = jsonDecode(rawText);

      final type = json['type'];

      if (type == 'tool_call') {
        return ToolCallOutput(
          toolName: json['toolName'],
          arguments: Map<String, dynamic>.from(json['arguments'] ?? {}),
        );
      }

      if (type == 'final_answer') {
        return FinalAnswerOutput(
          answer: json['answer'] ?? '',
        );
      }

      return FinalAnswerOutput(
        answer: 'Invalid agent response type.',
      );
    } catch (e) {
      return FinalAnswerOutput(
        answer: 'I could not understand the model response.',
      );
    }
  }
}