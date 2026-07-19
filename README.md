# local-llm-r

Run local LLMs from R via Ollama, with hardware-aware model selection via llm-checker.

## Setup
1. Install Ollama: https://ollama.com/download
2. Install Node.js: `scoop install nodejs`
3. Install llm-checker: `npm install -g llm-checker`
4. Sync the Ollama catalog: `llm-checker sync`
5. Run `scripts/00_install.R` to install R dependencies
6. Run `scripts/01_pull_models.R` to auto-select and pull models suited to your hardware

## Usage
See `examples/example_usage.R`
