import 'agent_trace.dart';

enum AgentStatus {
  idle,
  running,
  completed,
  failed,
  maxIterationsReached,
}

class AgentState {
  final String userMessage;
  final int maxIterations;
  final AgentTrace trace;

  AgentStatus status;
  int currentIteration;
  String? finalAnswer;
  String? error;

  AgentState({
    required this.userMessage,
    this.maxIterations = 5,
    AgentTrace? trace,
  })  : trace = trace ?? AgentTrace(),
        status = AgentStatus.idle,
        currentIteration = 0;

  bool get canContinue {
    return currentIteration < maxIterations &&
        status == AgentStatus.running;
  }
}