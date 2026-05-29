# Dart AI Agent

A robust AI Agent framework built with Dart and Flutter. This project enables Large Language Models to interact with tools and solve complex tasks through a reasoning-action loop.

## Features

- **Autonomous Agent**: Orchestrates complex task solving through multi-step reasoning.
- **Tool Integration**: Easily add custom tools for the agent to use.
- **LLM Agnostic**: Supports multiple LLM backends (currently configured for llama.cpp).
- **Full Traceability**: Detailed logging of every step, including prompts and tool results.

## Getting Started

### Prerequisites
- Flutter SDK
- A running LLM server (e.g., llama.cpp or any OpenAI-compatible API) at `http://localhost:8080`.

### Documentation
Detailed information about the architecture and features can be found in the [Architecture Documentation](docs/architecture.md).

## Project Structure

- `lib/agent_orchestrator.dart`: Main orchestration logic.
- `lib/llm/`: LLM client implementations.
- `lib/tools/`: Custom tools for the agent.
- `lib/parsers/`: Logic for parsing LLM outputs.
- `lib/models/`: Data models for agent state and tracing.
