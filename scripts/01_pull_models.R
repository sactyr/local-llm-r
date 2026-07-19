source("R/hardware_fit.R")
library(ollamar)
library(tictoc)

models_to_pull <- get_pullable_models(n = 3)
print(models_to_pull)

pull_times <- list()

for (m in models_to_pull) {
  tic(m)
  result <- tryCatch(pull(m), error = function(e) {
    message("Failed to pull ", m, ": ", conditionMessage(e))
    NULL
  })
  t <- toc(quiet = TRUE)
  pull_times[[m]] <- round(t$toc - t$tic, 1)
}

print(pull_times)
list_models()
