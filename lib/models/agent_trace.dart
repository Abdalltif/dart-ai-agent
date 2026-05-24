import 'agent_step.dart';

class AgentTrace {
  final List<AgentStep> steps = [];

  void addStep(AgentStep step) {
    steps.add(step);
  }

  List<Map<String, dynamic>> toJson() {
    return steps.map((step) => step.toJson()).toList();
  }

  void printTrace() {
    for (final step in steps) {
      print('--- Step ${step.index} ---');
      print('Tool: ${step.toolName}');
      print('Arguments: ${step.toolArguments}');
      print('Tool result: ${step.toolResult}');
      print('Final answer: ${step.finalAnswer}');
      print('');
    }
  }
}