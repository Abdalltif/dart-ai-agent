import 'ai_tool.dart';

class CalculatorTool implements AiTool {
  @override
  String get name => 'calculator';

  @override
  String get description => 'Use this tool to perform simple math calculations.';

  @override
  Map<String, dynamic> get inputSchema => {
    'expression': 'string',
  };

  @override
  Future<ToolResult> execute(Map<String, dynamic> input) async {
    try {
      final expression = input['expression'];

      if (expression == null || expression is! String) {
        return ToolResult.failure('Missing or invalid expression.');
      }

      final result = _calculate(expression);

      return ToolResult.success(result);
    } catch (e) {
      return ToolResult.failure(e.toString());
    }
  }

  double _calculate(String expression) {
    final clean = expression.replaceAll(' ', '');

    if (clean.contains('+')) {
      final parts = clean.split('+');
      return double.parse(parts[0]) + double.parse(parts[1]);
    }

    if (clean.contains('-')) {
      final parts = clean.split('-');
      return double.parse(parts[0]) - double.parse(parts[1]);
    }

    if (clean.contains('*')) {
      final parts = clean.split('*');
      return double.parse(parts[0]) * double.parse(parts[1]);
    }

    if (clean.contains('/')) {
      final parts = clean.split('/');
      return double.parse(parts[0]) / double.parse(parts[1]);
    }

    throw Exception('Unsupported expression. Example: 10 + 5');
  }
}