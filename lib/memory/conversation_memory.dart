import 'chat_message.dart';

class ConversationMemory {
  final int maxMessages;
  final List<ChatMessage> _messages = [];

  ConversationMemory({
    this.maxMessages = 10,
  });

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  void addUserMessage(String content) {
    _add(
      ChatMessage(
        role: ChatRole.user,
        content: content,
      ),
    );
  }

  void addAssistantMessage(String content) {
    _add(
      ChatMessage(
        role: ChatRole.assistant,
        content: content,
      ),
    );
  }

  void addToolMessage(String content) {
    _add(
      ChatMessage(
        role: ChatRole.tool,
        content: content,
      ),
    );
  }

  void clear() {
    _messages.clear();
  }

  String buildHistoryText() {
    if (_messages.isEmpty) {
      return 'No previous conversation.';
    }

    final buffer = StringBuffer();

    for (final message in _messages) {
      buffer.writeln('${message.roleName}: ${message.content}');
    }

    return buffer.toString();
  }

  void _add(ChatMessage message) {
    _messages.add(message);

    while (_messages.length > maxMessages) {
      _messages.removeAt(0);
    }
  }
}