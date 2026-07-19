pkgs <- c("ollamar", "dplyr", "ggplot2", "tictoc", "jsonlite")
install.packages(setdiff(pkgs, rownames(installed.packages())))

# renv::init()
# renv::snapshot()
