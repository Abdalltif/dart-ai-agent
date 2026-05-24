class PromptBuilder {
  String build({
    required String userMessage,
    required List<Map<String, dynamic>> tools,
    String? toolName,
    dynamic toolResult,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('You are a simple AI agent.');
    buffer.writeln();
    buffer.writeln('You can either answer directly or call a tool.');
    buffer.writeln();
    buffer.writeln('Available tools:');

    for (final tool in tools) {
      buffer.writeln('- ${tool['name']}: ${tool['description']}');
      buffer.writeln('  Input schema: ${tool['inputSchema']}');
    }

    buffer.writeln();
    buffer.writeln('User message: $userMessage');

    if (toolName != null) {
      buffer.writeln();
      buffer.writeln('Tool used: $toolName');
      buffer.writeln('Tool result: $toolResult');
    }

    return buffer.toString();
  }
}