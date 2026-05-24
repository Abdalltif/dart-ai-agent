sealed class AgentOutput {}

class ToolCallOutput extends AgentOutput {
  final String toolName;
  final Map<String, dynamic> arguments;

  ToolCallOutput({
    required this.toolName,
    required this.arguments,
  });
}

class FinalAnswerOutput extends AgentOutput {
  final String answer;

  FinalAnswerOutput({
    required this.answer,
  });
}