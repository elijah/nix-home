{ pkgs, ... }:
{
  # Model Context Protocol (MCP) and Local AI Hardware Support

  environment.systemPackages = with pkgs; [
    # MCP server and CLI (replace with actual package if available)
    # mcp-server
    # mcp-cli

    # Local LLM runners and frameworks
    ollama # Local LLM runner (supports GPU/NPU/TPU)
    lm-studio # Local LLM desktop app
    mlc-llm # MLC LLM for local inference (GPU/NPU/TPU)
    llama-cpp # Llama.cpp for local LLMs (CPU/GPU)
    # Add more as needed: exllama, vllm, etc.

    # GPU/NPU/TPU support
    nvidia-docker # For NVIDIA GPU containers (if on Linux)
    cudaPackages.cudatoolkit
    rocmPackages.rocminfo
    vulkan-tools
    # Add Apple Silicon/Metal support if needed
  ];

  # Python ML/AI libraries for local inference
  home.packages = with pkgs.python3Packages; [
    torch
    tensorflow
    jax
    transformers
    accelerate
    optimum
    sentencepiece
    huggingface-hub
    # Add more as needed
  ];

  # Environment variables for local model storage and hardware
  home.sessionVariables = {
    HF_HOME = "$HOME/.cache/huggingface";
    TRANSFORMERS_CACHE = "$HOME/.cache/huggingface/transformers";
    OLLAMA_MODELS = "$HOME/.ollama/models";
    MLC_CACHE = "$HOME/.cache/mlc";
    # Add CUDA/ROCm/Metal variables as needed
  };

  # Shell aliases for local LLM workflows
  environment.shellAliases = {
    "ollama-run" = "ollama run llama2";
    "lmstudio" = "lm-studio";
    "mlc-llm" = "mlc_llm";
    "llama-cpp" = "llama-cpp";
    # Add more as needed
  };

  # Optionally, add VS Code extensions for MCP/LLM dev
  # home.packages = with pkgs.vscode-extensions; [
  #   ms-toolsai.jupyter
  #   ms-python.python
  #   ms-toolsai.vscode-ai
  # ];
}
