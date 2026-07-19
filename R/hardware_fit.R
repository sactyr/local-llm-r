#' Get top N Ollama-pullable model recommendations from llm-checker
#'
#' llm-checker with --ollama-only restricts results to models available in
#' the Ollama catalog, and prints "ollama pull <tag>" lines in several
#' places (Pull:, Quick Start, Alternative options) - we grep all of them
#' and dedupe. Embedding/rerank models are excluded since they cannot be
#' used for text generation (llm-checker has occasionally recommended
#' qwen3-embedding under a "qwen3" display name - not a chat model).
get_pullable_models <- function(n = 3, use_case = NULL, request_limit = n + 5) {
  args <- c("check", "--limit", request_limit, "--ollama-only")
  if (!is.null(use_case)) args <- c(args, "--use-case", use_case)

  out <- system2("llm-checker", args, stdout = TRUE, stderr = TRUE)
  pull_lines <- grep("ollama pull", out, value = TRUE)
  model_names <- sub(".*ollama pull\\s+(\\S+).*", "\\1", pull_lines)
  model_names <- unique(model_names)

  model_names <- model_names[!grepl("embed|rerank", model_names, ignore.case = TRUE)]

  head(model_names, n)
}
