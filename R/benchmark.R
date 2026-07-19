library(dplyr)

#' Compare models on the same prompt: latency + actual char length achieved.
#' Uses the elapsed_sec attribute generate_response() attaches to its output,
#' rather than timing separately, so there is a single source of truth for timing.
benchmark_models <- function(models, prompt, max_chars = 5000) {
  results <- lapply(models, function(m) {
    resp <- generate_response(m, prompt, max_chars = max_chars)
    elapsed <- attr(resp, "elapsed_sec")

    data.frame(
      model         = m,
      elapsed_sec   = elapsed,
      chars_out     = nchar(resp),
      chars_per_sec = round(nchar(resp) / elapsed, 1)
    )
  })
  dplyr::bind_rows(results)
}
