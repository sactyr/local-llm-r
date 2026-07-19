# ollamar   - Ollama API client
# dplyr     - data wrangling for benchmark results
# ggplot2   - optional plotting of benchmark/pull-time data for the blog
# tictoc    - timing model pulls in scripts/01_pull_models.R
pkgs <- c("ollamar", "dplyr", "ggplot2", "tictoc")
install.packages(setdiff(pkgs, rownames(installed.packages())))

# renv::init()
# renv::snapshot()
