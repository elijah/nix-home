{ pkgs, ... }:
{
  # Model Context Protocol (MCP) and Local AI Hardware Support

  environment.systemPackages = with pkgs; [
    # Local LLM runners and frameworks
    ollama # Local LLM runner (supports GPU/NPU/TPU)

    # GPU/NPU/TPU support
    vulkan-tools

    # Python ML/AI libraries for local inference
    python3
    python3Packages.torch
    python3Packages.transformers
    python3Packages.accelerate
    python3Packages.sentencepiece
    python3Packages.huggingface-hub
  ];

  # Environment variables for local model storage and hardware
  environment.variables = {
    HF_HOME = "$HOME/.cache/huggingface";
    TRANSFORMERS_CACHE = "$HOME/.cache/huggingface/transformers";
    OLLAMA_MODELS = "$HOME/.ollama/models";
  };

  # Shell aliases for local LLM workflows
  environment.shellAliases = {
    "ollama-run" = "ollama run llama2";
  };
}
