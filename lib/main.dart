import 'package:dart_ai_agent/parsers/agent_output_parser.dart';

import 'agent_orchestrator.dart';
import 'llm_client.dart';
import 'prompt_builder.dart';
import 'tool_router.dart';
import 'tools/calculator_tool.dart';

Future<void> main() async {
  final toolRouter = ToolRouter([
    CalculatorTool(),
  ]);

  final agent = AgentOrchestrator(
    llmClient: FakeLLMClient(),
    toolRouter: toolRouter,
    promptBuilder: PromptBuilder(),
    outputParser: AgentOutputParser(),
  );

  final result = await agent.run('What is 25 * 4?');

  print(result.answer);

  print('');
  print('Agent trace:');
  result.state.trace.printTrace();
}