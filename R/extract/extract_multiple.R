# Logic for pivoting multiple-choice variables
extract.multiple_choice <- function(x, data, ...) {
  library(data.table)
  data <- as.data.table(data)
  
  # bring mc-columns in long format
  res <- melt(data, id.vars = "id", measure.vars = patterns(x$prefix),
              variable.name = "answer1", variable.factor = FALSE)
  
  res$answer1 <- gsub("^.*?:", "", res$answer1)
  res$answer1 <- gsub("^\\s", "", res$answer1)
  
  all_answers <- unique(res$answer1)
  
  res <- as.data.frame(res)
  res$answer1 <- factor(res$answer1, levels = all_answers)
  
  return(list(meta = x,
              data = res[, c("id", "answer1")]))
  
}
