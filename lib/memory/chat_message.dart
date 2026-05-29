enum ChatRole {
  user,
  assistant,
  tool,
}

class ChatMessage {
  final ChatRole role;
  final String content;
  final DateTime createdAt;

  ChatMessage({
    required this.role,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get roleName {
    switch (role) {
      case ChatRole.user:
        return 'user';
      case ChatRole.assistant:
        return 'assistant';
      case ChatRole.tool:
        return 'tool';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'role': roleName,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}