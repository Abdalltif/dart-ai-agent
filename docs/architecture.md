# Dart AI Agent - Features and Architecture

## Overview
This project is a Dart implementation of an AI Agent capable of using tools to solve tasks. It follows a reasoning-action loop where the LLM can either call a tool or provide a final answer based on the context.

## Features
- **Structured AI Loop**: Implements a robust `AgentOrchestrator` that manages the cycle of prompting, parsing, and execution.
- **Pluggable Tool System**: Easily extend the agent's capabilities by adding new tools implementing the `AiTool` interface.
- **LLM Independence**: Uses an `LLMClient` abstraction, allowing for different backends. Currently supports `LlamaCppClient`.
- **Comprehensive Traceability**: Captures every step of the agent's execution, including prompts, raw responses, tool calls, and results.
- **JSON-based Communication**: Uses a structured JSON format for reliable communication between the agent and the LLM.
- **Safety & Constraints**: Supports maximum iterations to prevent infinite loops.

## Architecture

### Component Diagram
The system is composed of several key components working together:

1.  **AgentOrchestrator**: The central brain that coordinates the execution loop. It maintains the `AgentState`.
2.  **PromptBuilder**: Responsible for constructing the prompt sent to the LLM. It includes:
    *   System instructions.
    *   Tool definitions.
    *   The user's request.
    *   Previous tool results (if any).
3.  **LLMClient**: A standard interface for interacting with Large Language Models.
    *   `LlamaCppClient`: An implementation that talks to an OpenAI-compatible API (e.g., llama.cpp).
4.  **AgentOutputParser**: Parses the raw text output from the LLM into structured `AgentOutput` objects (`ToolCallOutput` or `FinalAnswerOutput`).
5.  **ToolRouter**: Manages a collection of `AiTool`s. It routes tool calls from the LLM to the correct implementation and returns the result.
6.  **Models**:
    *   `AgentState`: Tracks the overall progress of a single run.
    *   `AgentTrace`: A collection of `AgentStep`s representing the history.
    *   `AgentStep`: A single iteration's data.

### Execution Flow
1.  **Start**: `AgentOrchestrator.run(userMessage)` is called.
2.  **Prompting**: `PromptBuilder` creates a prompt.
3.  **Generation**: `LLMClient` sends the prompt to the model and receives a response.
4.  **Parsing**: `AgentOutputParser` converts the response into an action.
5.  **Branching**:
    *   If **Final Answer**: The loop terminates, and the answer is returned.
    *   If **Tool Call**: 
        *   `ToolRouter` executes the requested tool.
        *   The result is saved to the state.
        *   The loop repeats from step 2, with the tool result included in the next prompt.
6.  **Safety**: If `maxIterations` is reached, the agent stops with an error.
