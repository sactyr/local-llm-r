#' Very small templating helper - swap {{placeholder}} tokens in a base prompt
build_prompt <- function(template, ...) {
  vals <- list(...)
  for (nm in names(vals)) {
    template <- gsub(paste0("\\{\\{", nm, "\\}\\}"), vals[[nm]], template)
  }
  template
}
