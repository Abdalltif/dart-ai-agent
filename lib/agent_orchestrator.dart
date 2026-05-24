import 'llm_client.dart';
import 'prompt_builder.dart';
import 'tool_router.dart';

class AgentOrchestrator {
  final LLMClient llmClient;
  final ToolRouter toolRouter;
  final PromptBuilder promptBuilder;

  AgentOrchestrator({
    required this.llmClient,
    required this.toolRouter,
    required this.promptBuilder,
  });

  Future<String> run(String userMessage) async {
    final tools = toolRouter.getToolDefinitions();

    var prompt = promptBuilder.build(
      userMessage: userMessage,
      tools: tools,
    );

    for (var i = 0; i < 3; i++) {
      final response = await llmClient.generate(prompt);

      if (response is FinalAnswerResponse) {
        return response.answer;
      }

      if (response is ToolCallResponse) {
        final toolResult = await toolRouter.execute(
          toolName: response.toolName,
          input: response.arguments,
        );

        prompt = promptBuilder.build(
          userMessage: userMessage,
          tools: tools,
          toolName: response.toolName,
          toolResult: toolResult.toJson(),
        );

        continue;
      }
    }

    return 'I could not complete the task.';
  }
}