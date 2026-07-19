# local-llm-r

Run local LLMs from R via Ollama, with hardware-aware model selection via llmfit.

## Setup
1. Install Ollama: https://ollama.com/download
2. Install llmfit: `scoop install llmfit`
3. Run `scripts/00_install.R` to install R dependencies
4. Run `scripts/01_pull_models.R` to auto-select and pull models suited to your hardware

## Usage
See `examples/example_usage.R`
