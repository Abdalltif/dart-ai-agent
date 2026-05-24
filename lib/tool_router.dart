import 'tools/ai_tool.dart';

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
      return ToolResult.failure('Tool not found: $toolName');
    }

    return tool.execute(input);
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