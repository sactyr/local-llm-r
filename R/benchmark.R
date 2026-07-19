library(tictoc)
library(dplyr)

#' Compare models on the same prompt: latency + actual char length achieved
benchmark_models <- function(models, prompt, max_chars = 5000) {
  results <- lapply(models, function(m) {
    tic()
    out <- generate_response(m, prompt, max_chars = max_chars)
    t <- toc(quiet = TRUE)

    data.frame(
      model         = m,
      elapsed_sec   = round(t$toc - t$tic, 1),
      chars_out     = nchar(out),
      chars_per_sec = round(nchar(out) / (t$toc - t$tic), 1)
    )
  })
  dplyr::bind_rows(results)
}
