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

#' Truncate text to at most max_chars, preferring a sentence boundary over
#' a hard character cutoff. Falls back to the last word boundary if the
#' nearest sentence end would cut off more than half the target length.
truncate_response <- function(text, max_chars) {
  if (nchar(text) <= max_chars) return(text)

  truncated <- substr(text, 1, max_chars)
  sentence_ends <- gregexpr("[.!?]", truncated)[[1]]

  if (sentence_ends[1] > 0) {
    last_sentence_end <- max(sentence_ends)
    if (last_sentence_end > max_chars * 0.5) {
      return(substr(truncated, 1, last_sentence_end))
    }
  }

  # fallback: cut at the last word boundary instead of mid-word
  last_space <- max(gregexpr(" ", truncated)[[1]])
  if (last_space > 0) {
    return(substr(truncated, 1, last_space - 1))
  }

  truncated
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
  text <- truncate_response(body$message$content, max_chars)
  attr(text, "elapsed_sec") <- elapsed
  text
}
