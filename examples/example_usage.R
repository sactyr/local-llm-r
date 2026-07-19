source("R/ollama_client.R")
source("R/prompt_builder.R")
source("R/benchmark.R")
source("R/hardware_fit.R")

check_ollama_running()
models <- list_local_models()
print(models)

prompt <- build_prompt(
  "Write a {{length}}-word technical summary about {{topic}}.",
  length = "500", topic = "setting up local LLMs in R with Ollama"
)

resp <- generate_response(models$name[1], prompt, max_chars = 5000)
cat(resp)

bench <- benchmark_models(models$name, prompt)
print(bench)
