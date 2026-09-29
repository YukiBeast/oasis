# Logic for single-choice or numeric categorized variables

# R/extract/extract_single_choice.R

extract.single_choice <- function(x, data, ...) {
  # x: the card object from the deck (e.g., deck$CC01)
  # data: the raw survey dataset
  
  # Isolate the exact column using the card's name
  raw_col <- data[[x$name]]
  
  # 1. Handle Binned Numeric (if breaks exist)
  if (!is.null(x$breaks)) {
    processed_col <- cut(raw_col, breaks = x$breaks, include.lowest = TRUE)
    
    # 2. Handle Ordinal (if predefined levels from the scales dictionary exist)
  } else if (!is.null(x$levels)) {
    processed_col <- factor(raw_col, levels = x$levels, ordered = TRUE)
    
    # 3. Handle Standard Categorical
  } else {
    processed_col <- as.factor(raw_col)
  }
  
  # Build a standardized frequency table for the plotting classes
  freq_table <- as.data.frame(table(processed_col, useNA = "no"))
  names(freq_table) <- c("category", "count")
  
  # Calculate valid percentages
  freq_table$percentage <- (freq_table$count / sum(freq_table$count)) * 100
  
  # Return the finalized table bundled with the card's metadata
  return(list(
    meta = x,
    data = freq_table
  ))
}