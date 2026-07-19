source("R/ollama_client.R")
check_ollama_running()

models <- c("gemma3", "qwen3.5", "qwen3.6")
prompt <- "Write a 3-sentence summary of what a GTX 1080 is."

responses <- list()
results <- lapply(models, function(m) {
  message("Generating with ", m, "...")
  resp <- generate_response(m, prompt, max_chars = 500)
  responses[[m]] <<- resp
  data.frame(
    model         = m,
    elapsed_sec   = attr(resp, "elapsed_sec"),
    chars_out     = nchar(resp),
    chars_per_sec = round(nchar(resp) / attr(resp, "elapsed_sec"), 1)
  )
})

comparison <- do.call(rbind, results)
print(comparison)
