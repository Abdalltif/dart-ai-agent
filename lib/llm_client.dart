abstract class LLMClient {
  Future<String> generate(String prompt);
}

class FakeLLMClient implements LLMClient {
  @override
  Future<String> generate(String prompt) async {
    final lowerPrompt = prompt.toLowerCase();

    final hasToolResult = lowerPrompt.contains('tool result:');

    if (hasToolResult) {
      final result = _extractToolResult(prompt);

      return '''
{
  "type": "final_answer",
  "answer": "The answer is $result."
}
''';
    }

    final expression = _extractMathExpression(prompt);

    if (expression != null) {
      return '''
{
  "type": "tool_call",
  "toolName": "calculator",
  "arguments": {
    "expression": "$expression"
  }
}
''';
    }

    return '''
{
  "type": "final_answer",
  "answer": "I can only answer simple math questions for now."
}
''';
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