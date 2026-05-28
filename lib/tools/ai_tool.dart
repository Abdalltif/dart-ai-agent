import 'package:dart_ai_agent/tools/tool_result.dart';
import 'package:dart_ai_agent/tools/tool_validation_result.dart';

abstract class AiTool {
  String get name;

  String get description;

  Map<String, dynamic> get inputSchema;

  ToolValidationResult validate(Map<String, dynamic> input);

  Future<ToolResult> execute(Map<String, dynamic> input);
}
