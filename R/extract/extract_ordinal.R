extract.ordinal <- function(x, data, ...) {
  
  # x: the card object from the deck (e.g., deck$CC01) with class ("binned", "single")
  # will have:
  #   - x$name: a string e.g. "CC01" indicating the item's col name in the data
  #   - x$label: a string e.g. "Sport frequency" indicating which name should the variable have in the UI
  #   - x$levels: a character vector e.g. c("never", "sometimes", "always") indicating the answer's plotting order
  
  # data: dataframe, the raw survey dataset
  
  # output:
  # list containing:
  #   - meta: the same x given an input
  #   - data: a dataframe with column
  #       - id (numeric)
  #       - answer1, indicating the given answers
  
  # Isolate the exact column using the card's name
  raw_col <- data[[x$name]]
  
  if (all(is.na(raw_col))) {
    return(return_empty_data(x))
  }
  
  # ToDo
  data$answer1 <- factor(raw_col, levels = x$levels, ordered = TRUE)
  
  output <- data[, c("id", "answer1")]
  
  return(list(meta = x,
              data = output))
  
}