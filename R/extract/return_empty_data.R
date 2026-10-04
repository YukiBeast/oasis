return_empty_data <- function(x) {

  # This function should just return a unified datased indicating that the dataset contains no
  # valid data for the chosen variable x
    return(
      list(meta = x,
           data = data.frame(id = numeric(0),
                             answer1 = character(0))
           )
    )
  
}
