import 'package:dart_ai_agent/parsers/agent_output_parser.dart';

import 'llm/llm_client.dart';
import 'models/agent_output.dart';
import 'models/agent_state.dart';
import 'models/agent_step.dart';
import 'prompt_builder.dart';
import 'tool_router.dart';

class AgentRunResult {
  final String answer;
  final AgentState state;

  AgentRunResult({
    required this.answer,
    required this.state,
  });
}

class AgentOrchestrator {
  final LLMClient llmClient;
  final ToolRouter toolRouter;
  final PromptBuilder promptBuilder;
  final AgentOutputParser outputParser;

  AgentOrchestrator({
    required this.llmClient,
    required this.toolRouter,
    required this.promptBuilder,
    required this.outputParser,
  });

  Future<AgentRunResult> run(String userMessage) async {
    final state = AgentState(
      userMessage: userMessage,
      maxIterations: 5,
    );

    state.status = AgentStatus.running;

    final tools = toolRouter.getToolDefinitions();

    String? lastToolName;
    Map<String, dynamic>? lastToolResult;

    while (state.canContinue) {
      state.currentIteration++;

      final prompt = promptBuilder.build(
        userMessage: userMessage,
        tools: tools,
        toolName: lastToolName,
        toolResult: lastToolResult,
      );

      final rawResponse = await llmClient.generate(prompt);
      final output = outputParser.parse(rawResponse);

      if (output is FinalAnswerOutput) {
        state.finalAnswer = output.answer;
        state.status = AgentStatus.completed;

        state.trace.addStep(
          AgentStep(
            index: state.currentIteration,
            prompt: prompt,
            rawLlmResponse: rawResponse,
            finalAnswer: output.answer,
          ),
        );

        return AgentRunResult(
          answer: output.answer,
          state: state,
        );
      }

      if (output is ToolCallOutput) {
        final toolResult = await toolRouter.execute(
          toolName: output.toolName,
          input: output.arguments,
        );

        lastToolName = output.toolName;
        lastToolResult = toolResult.toJson();

        state.trace.addStep(
          AgentStep(
            index: state.currentIteration,
            prompt: prompt,
            rawLlmResponse: rawResponse,
            toolName: output.toolName,
            toolArguments: output.arguments,
            toolResult: toolResult.toJson(),
          ),
        );

        continue;
      }
    }

    state.status = AgentStatus.maxIterationsReached;
    state.error = 'Max iterations reached.';

    return AgentRunResult(
      answer: 'I could not complete the task.',
      state: state,
    );
  }
}