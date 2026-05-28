import 'package:dart_ai_agent/tools/ai_tool.dart';
import 'package:dart_ai_agent/tools/tool_result.dart';

class ToolRouter {
  final Map<String, AiTool> _tools;

  ToolRouter(List<AiTool> tools)
      : _tools = {
    for (final tool in tools) tool.name: tool,
  };

  Future<ToolResult> execute({
    required String toolName,
    required Map<String, dynamic> input,
  }) async {
    final tool = _tools[toolName];

    if (tool == null) {
      return ToolResult.notFound('Tool not found: $toolName');
    }

    final validation = tool.validate(input);

    if (!validation.isValid) {
      return ToolResult.validationError(validation.error);
    }

    try {
      return await tool.execute(input);
    } catch (e) {
      return ToolResult.executionError(e.toString());
    }
  }

  List<Map<String, dynamic>> getToolDefinitions() {
    return _tools.values.map((tool) {
      return {
        'name': tool.name,
        'description': tool.description,
        'inputSchema': tool.inputSchema,
      };
    }).toList();
  }
}