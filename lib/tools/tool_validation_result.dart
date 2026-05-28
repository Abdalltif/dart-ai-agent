class ToolValidationResult {
  final bool isValid;
  final String? error;

  const ToolValidationResult.valid()
      : isValid = true,
        error = null;

  const ToolValidationResult.invalid(this.error)
      : isValid = false;
}