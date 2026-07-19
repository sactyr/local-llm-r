library(ollamar)

#' Check the Ollama server is reachable before doing anything else
check_ollama_running <- function() {
  ok <- tryCatch(ollamar::test_connection(), error = function(e) FALSE)
  if (!isTRUE(ok)) {
    stop("Ollama is not reachable at localhost:11434 - is `ollama serve` running?")
  }
  invisible(TRUE)
}

#' List models currently pulled locally
list_local_models <- function() {
  ollamar::list_models()
}

#' Generate a response of roughly `max_chars` characters
generate_response <- function(model, prompt, max_chars = 5000, temperature = 0.7) {
  check_ollama_running()

  n_predict <- ceiling(max_chars / 4 * 1.15)

  resp <- ollamar::generate(
    model  = model,
    prompt = prompt,
    output = "text",
    num_predict = n_predict,
    temperature = temperature
  )

  substr(resp, 1, max_chars)
}
