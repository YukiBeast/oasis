extract.binned <- function(x, data, ...) {
  
  # x: the card object from the deck (e.g., deck$CC01) with class ("binned", "single")
  # will have:
  #   - x$name: a string e.g. "BB01" indicating the item's col name in the data
  #   - x$label: a string e.g. "Age binned" indicating which name should the variable have in the UI
  #   - x$breaks: a numeric vector e.g. c(0, 18, 35, 65, Inf) indicating which category the answer should belong to
  
  # data: dataframe, the raw survey dataset
  
  # output:
  # list containing:
  #   - meta: the same x given an input
  #   - data: a dataframe with column
  #       - id (numeric)
  #       - answer1, indicating to which category the given answers belong
  
  # Isolate the exact column using the card's name
  raw_col <- data[[x$name]]
  
  if (all(is.na(raw_col))) {
    return(return_empty_data(x))
  }
  
  # Get the breaks from the Codebook configuration
  x_breaks <- x$breaks 
  
  # Generate the pretty labels
  pretty_labels <- generate_nice_labels(x_breaks)
  
  # Cut the data using the pretty labels
  data$answer1 <- cut(
    raw_col, 
    breaks = x_breaks,
    labels = pretty_labels,
    ordered_result = TRUE,
    right = FALSE
  )
  
  output <- data[, c("id", "answer1")]
  
  return(list(meta = x,
              data = output))
}

generate_nice_labels <- function(breaks) {
  
  labels <- character(length(breaks) - 1)
  
  for (i in seq_len((length(breaks) - 1))) {
    lower <- breaks[[i]]
    upper <- breaks[[i + 1]] - 1
    
    if (is.infinite(upper)) {
      labels[i] <- paste0(lower, "+")
    } else {
      labels[i] <- paste0(lower, "-", upper)
    }
  }
  
  return(labels)
}
