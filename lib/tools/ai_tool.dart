abstract class AiTool {
  String get name;

  String get description;

  Map<String, dynamic> get inputSchema;

  Future<ToolResult> execute(Map<String, dynamic> input);
}

class ToolResult {
  final bool success;
  final dynamic data;
  final String? error;

  ToolResult.success(this.data)
      : success = true,
        error = null;

  ToolResult.failure(this.error)
      : success = false,
        data = null;

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      'error': error,
    };
  }
}