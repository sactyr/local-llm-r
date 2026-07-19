library(jsonlite)

#' Ask llmfit for its top N recommended models for this machine
get_recommended_models <- function(limit = 10, use_case = NULL) {
  args <- c("recommend", "--json", "--limit", limit)
  if (!is.null(use_case)) args <- c(args, "--use-case", use_case)

  out <- system2("llmfit", args, stdout = TRUE, stderr = TRUE)
  parsed <- jsonlite::fromJSON(paste(out, collapse = "\n"), simplifyVector = FALSE)
  parsed$models
}

#' Resolve one llmfit model entry to something ollamar::pull() can use.
#' Returns NA if there is no usable GGUF path (e.g. MLX or bnb-only models).
resolve_ollama_pull_name <- function(model) {
  if (!is.null(model$ollama_name) && nzchar(model$ollama_name)) {
    return(model$ollama_name)
  }
  if (length(model$gguf_sources) > 0) {
    repo <- model$gguf_sources[[1]]$repo
    return(paste0("hf.co/", repo, ":", model$best_quant))
  }
  if (grepl("gguf", model$name, ignore.case = TRUE)) {
    return(paste0("hf.co/", model$name, ":", model$best_quant))
  }
  NA_character_
}

#' Get the top n Ollama-pullable models from llmfit's recommendations.
get_pullable_models <- function(n = 3, use_case = NULL, request_limit = 10) {
  models <- get_recommended_models(limit = request_limit, use_case = use_case)
  pull_names <- vapply(models, resolve_ollama_pull_name, character(1))
  valid <- pull_names[!is.na(pull_names)]
  head(valid, n)
}
