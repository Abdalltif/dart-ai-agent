enum ToolResultStatus {
  success,
  validationError,
  notFound,
  executionError,
  permissionDenied,
}

class ToolResult {
  final ToolResultStatus status;
  final dynamic data;
  final String? error;

  ToolResult.success(this.data)
      : status = ToolResultStatus.success,
        error = null;

  ToolResult.validationError(this.error)
      : status = ToolResultStatus.validationError,
        data = null;

  ToolResult.notFound(this.error)
      : status = ToolResultStatus.notFound,
        data = null;

  ToolResult.executionError(this.error)
      : status = ToolResultStatus.executionError,
        data = null;

  ToolResult.permissionDenied(this.error)
      : status = ToolResultStatus.permissionDenied,
        data = null;

  bool get isSuccess => status == ToolResultStatus.success;

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'data': data,
      'error': error,
    };
  }
}