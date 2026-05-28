import 'package:dart_ai_agent/parsers/agent_output_parser.dart';
import 'package:dart_ai_agent/prompt_builder.dart';
import 'package:dart_ai_agent/tool_router.dart';
import 'package:dart_ai_agent/tools/calculator_tool.dart';
import 'package:flutter/material.dart';

import 'agent_orchestrator.dart';
import 'llm/llama_cpp_client.dart';


void main() {
  runApp(const MyApp());
}

const llamaServerUrl = 'http://localhost:8080';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple AI Agent',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  const ChatMessage({
    required this.text,
    required this.isUser,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final AgentOrchestrator _agent;

  final TextEditingController _controller = TextEditingController();

  final List<ChatMessage> _messages = [
    const ChatMessage(
      text: 'Ask me a simple math question. Example: What is 25 * 4?',
      isUser: false,
    ),
  ];

  bool _isSending = false;

  @override
  void initState() {
    super.initState();

    final llmClient = LlamaCppClient(
      baseUrl: llamaServerUrl,
      model: 'local-model',
    );

    final toolRouter = ToolRouter([
      CalculatorTool(),
    ]);

    _agent = AgentOrchestrator(
      llmClient: llmClient,
      toolRouter: toolRouter,
      promptBuilder: PromptBuilder(),
      outputParser: AgentOutputParser(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();

    if (text.isEmpty || _isSending) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
        ),
      );
      _controller.clear();
      _isSending = true;
    });

    try {
      final result = await _agent.run(text);

      setState(() {
        _messages.add(
          ChatMessage(
            text: result.answer,
            isUser: false,
          ),
        );
      });

      debugPrint('Agent trace: ${result.state.trace.toJson()}');
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: '''
Could not connect to llama.cpp server.

Make sure it is running at:
$llamaServerUrl

Error:
$e
''',
            isUser: false,
          ),
        );
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple AI Agent'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 340),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(message.text),
                  ),
                );
              },
            ),
          ),
          if (_isSending)
            const LinearProgressIndicator(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_isSending,
                      decoration: const InputDecoration(
                        hintText: 'Ask: What is 25 * 4?',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _isSending ? null : _sendMessage,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}