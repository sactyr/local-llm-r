library(httr2)

#' Check the Ollama server is reachable before doing anything else
check_ollama_running <- function() {
  ok <- tryCatch(ollamar::test_connection(logical = TRUE), error = function(e) FALSE)
  if (!isTRUE(ok)) {
    stop("Ollama is not reachable at localhost:11434 - is `ollama serve` running?")
  }
  invisible(TRUE)
}

#' List models currently pulled locally
list_local_models <- function() {
  ollamar::list_models()
}

#' Generate a response of roughly `max_chars` characters.
#' Uses the /api/chat endpoint directly with think=FALSE at the top level -
#' the /api/generate endpoint (used by ollamar::generate()) has a known bug
#' where it ignores think=false for reasoning models (Qwen3, DeepSeek-R1),
#' burning the whole token budget on hidden reasoning and returning an
#' empty response. See https://github.com/ollama/ollama/issues/14793.
#' Non-reasoning models (e.g. gemma3) simply ignore the think field.
generate_response <- function(model, prompt, max_chars = 5000, temperature = 0.7) {
  check_ollama_running()
  n_predict <- ceiling(max_chars / 4 * 1.15)

  t0 <- Sys.time()
  resp <- request("http://localhost:11434/api/chat") |>
    req_body_json(list(
      model = model,
      messages = list(list(role = "user", content = prompt)),
      stream = FALSE,
      think = FALSE,
      options = list(num_predict = n_predict, temperature = temperature)
    )) |>
    req_perform()
  elapsed <- round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1)

  body <- resp_body_json(resp)
  text <- substr(body$message$content, 1, max_chars)
  attr(text, "elapsed_sec") <- elapsed
  text
}
