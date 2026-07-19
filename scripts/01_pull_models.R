source("R/hardware_fit.R")
library(ollamar)

models_to_pull <- get_pullable_models(n = 3, request_limit = 10)
print(models_to_pull)

for (m in models_to_pull) {
  result <- tryCatch(pull(m), error = function(e) {
    message("Failed to pull ", m, ": ", conditionMessage(e))
    NULL
  })
}

list_models()
