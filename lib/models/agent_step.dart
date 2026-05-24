class AgentStep {
  final int index;
  final String prompt;
  final String rawLlmResponse;
  final String? toolName;
  final Map<String, dynamic>? toolArguments;
  final Map<String, dynamic>? toolResult;
  final String? finalAnswer;
  final DateTime createdAt;

  AgentStep({
    required this.index,
    required this.prompt,
    required this.rawLlmResponse,
    this.toolName,
    this.toolArguments,
    this.toolResult,
    this.finalAnswer,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'prompt': prompt,
      'rawLlmResponse': rawLlmResponse,
      'toolName': toolName,
      'toolArguments': toolArguments,
      'toolResult': toolResult,
      'finalAnswer': finalAnswer,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}