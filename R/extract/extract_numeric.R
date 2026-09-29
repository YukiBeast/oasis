# Logic for numeric continuous variables

# R/extract/extract_numeric.R

extract.numeric <- function(x, data, ...) {
  
  raw_col <- data[[x$name]]
  
  # Simply clean out NAs and ensure it is numeric
  processed_col <- as.numeric(stats::na.omit(raw_col))
  
  return(list(
    meta = x,
    data = processed_col
  ))
}