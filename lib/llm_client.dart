abstract class LLMClient {
  Future<LLMResponse> generate(String prompt);
}

abstract class LLMResponse {}

class ToolCallResponse extends LLMResponse {
  final String toolName;
  final Map<String, dynamic> arguments;

  ToolCallResponse({
    required this.toolName,
    required this.arguments,
  });
}

class FinalAnswerResponse extends LLMResponse {
  final String answer;

  FinalAnswerResponse(this.answer);
}

class FakeLLMClient implements LLMClient {
  @override
  Future<LLMResponse> generate(String prompt) async {
    final lowerPrompt = prompt.toLowerCase();

    final hasToolResult = lowerPrompt.contains('tool result:');

    if (hasToolResult) {
      final result = _extractToolResult(prompt);

      return FinalAnswerResponse(
        'The answer is $result.',
      );
    }

    final expression = _extractMathExpression(prompt);

    if (expression != null) {
      return ToolCallResponse(
        toolName: 'calculator',
        arguments: {
          'expression': expression,
        },
      );
    }

    return FinalAnswerResponse(
      'I can only answer simple math questions for now.',
    );
  }

  String? _extractMathExpression(String prompt) {
    final regex = RegExp(r'(\d+)\s*([\+\-\*\/])\s*(\d+)');
    final match = regex.firstMatch(prompt);

    if (match == null) return null;

    return '${match.group(1)} ${match.group(2)} ${match.group(3)}';
  }

  String _extractToolResult(String prompt) {
    final regex = RegExp(r'Tool result:\s*(.*)');
    final match = regex.firstMatch(prompt);

    if (match == null) return 'unknown';

    return match.group(1) ?? 'unknown';
  }
}