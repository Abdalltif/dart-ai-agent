import 'package:dart_ai_agent/tools/tool_result.dart';
import 'package:dart_ai_agent/tools/tool_validation_result.dart';

import 'ai_tool.dart';

class CalculatorTool implements AiTool {
  @override
  String get name => 'calculator';

  @override
  String get description => 'Use this tool to perform simple math calculations.';

  @override
  Map<String, dynamic> get inputSchema => {
    'expression': 'string. Example: "10 + 5", "20 * 3", "100 / 4"',
  };

  @override
  ToolValidationResult validate(Map<String, dynamic> input) {
    final expression = input['expression'];

    if (expression == null) {
      return const ToolValidationResult.invalid(
        'Missing required field: expression.',
      );
    }

    if (expression is! String) {
      return const ToolValidationResult.invalid(
        'The field "expression" must be a string.',
      );
    }

    if (expression.trim().isEmpty) {
      return const ToolValidationResult.invalid(
        'The field "expression" cannot be empty.',
      );
    }

    final isSupportedExpression = _isSupportedExpression(expression);

    if (!isSupportedExpression) {
      return const ToolValidationResult.invalid(
        'Unsupported math expression. Use this format: number operator number. Example: 10 + 5',
      );
    }

    return const ToolValidationResult.valid();
  }

  @override
  Future<ToolResult> execute(Map<String, dynamic> input) async {
    final expression = input['expression'] as String;

    final result = _calculate(expression);

    return ToolResult.success(result);
  }

  bool _isSupportedExpression(String expression) {
    final clean = expression.trim();

    final regex = RegExp(
      r'^\s*-?\d+(\.\d+)?\s*[\+\-\*\/]\s*-?\d+(\.\d+)?\s*$',
    );

    return regex.hasMatch(clean);
  }

  double _calculate(String expression) {
    final clean = expression.replaceAll(' ', '');

    final regex = RegExp(
      r'^(-?\d+(?:\.\d+)?)([\+\-\*\/])(-?\d+(?:\.\d+)?)$',
    );

    final match = regex.firstMatch(clean);

    if (match == null) {
      throw Exception('Unsupported expression. Example: 10 + 5');
    }

    final left = double.parse(match.group(1)!);
    final operator = match.group(2)!;
    final right = double.parse(match.group(3)!);

    switch (operator) {
      case '+':
        return left + right;

      case '-':
        return left - right;

      case '*':
        return left * right;

      case '/':
        if (right == 0) {
          throw Exception('Division by zero is not allowed.');
        }

        return left / right;

      default:
        throw Exception('Unsupported operator: $operator');
    }
  }
}