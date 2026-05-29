class PromptBuilder {
  String build({
    required String userMessage,
    required List<Map<String, dynamic>> tools,
    required String conversationHistory,
    String? toolName,
    dynamic toolResult,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('You are inside an AI agent loop.');
    buffer.writeln();
    buffer.writeln('Return valid JSON only.');
    buffer.writeln('Do not use markdown.');
    buffer.writeln('Do not explain outside the JSON.');
    buffer.writeln();

    buffer.writeln('Available tools:');
    for (final tool in tools) {
      buffer.writeln('- name: ${tool['name']}');
      buffer.writeln('  description: ${tool['description']}');
      buffer.writeln('  inputSchema: ${tool['inputSchema']}');
    }

    buffer.writeln();
    buffer.writeln('Conversation history:');
    buffer.writeln(conversationHistory);

    buffer.writeln();
    buffer.writeln('Current user message:');
    buffer.writeln(userMessage);

    buffer.writeln();
    buffer.writeln('Allowed JSON outputs:');
    buffer.writeln('Tool call:');
    buffer.writeln(
      '{"type":"tool_call","toolName":"calculator","arguments":{"expression":"10 + 5"}}',
    );
    buffer.writeln();
    buffer.writeln('Final answer:');
    buffer.writeln(
      '{"type":"final_answer","answer":"10 + 5 equals 15."}',
    );

    if (toolName != null && toolResult != null) {
      buffer.writeln();
      buffer.writeln('A tool was executed.');
      buffer.writeln('Tool name: $toolName');
      buffer.writeln('Tool result: $toolResult');
      buffer.writeln();
      buffer.writeln('Now return final_answer JSON only.');
    } else {
      buffer.writeln();
      buffer.writeln('Decide whether to call a tool or return final_answer.');
    }

    return buffer.toString();
  }
}