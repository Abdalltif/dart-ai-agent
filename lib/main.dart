import 'agent_orchestrator.dart';
import 'llm_client.dart';
import 'prompt_builder.dart';
import 'tool_router.dart';
import 'tools/calculator_tool.dart';

Future<void> main() async {
  final calculatorTool = CalculatorTool();

  final toolRouter = ToolRouter([
    calculatorTool,
  ]);

  final llmClient = FakeLLMClient();

  final promptBuilder = PromptBuilder();

  final agent = AgentOrchestrator(
    llmClient: llmClient,
    toolRouter: toolRouter,
    promptBuilder: promptBuilder,
  );

  final answer = await agent.run('What is 10 + 5?');

  print(answer);
}