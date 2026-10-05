library(checkmate)
source(here("R/models/plot_payload.R"))

resolve_payload <- function(user_data, user_choice) {
  assert_class(user_data, "UserData")
  assert_class(user_choice, "UserChoice")
  
  settings <- list(share = user_choice$share,
                   language = user_choice$language,
                   bar_pos = user_choice$bar_pos,
                   fix_y = user_choice$fix_y,
                   show_legend = user_choice$show_legend)
  
  # univariate case, just return the extracted chosen variable
  if (is.null(user_choice$item2)) {
    
    output <- extract(user_data$deck[[user_choice$item1]], user_data$data)$data
    
    meta <- list(item1 = user_data$deck[[user_choice$item1]],
                 item2 = NULL)
    
    return(list(data = output,
                meta = meta,
                settings = settings))
  }
  
  # else: bivariate case --> full join extracted variable 1 and variable 2 on column 'id'
  extracted1 <- extract(user_data$deck[[user_choice$item1]], user_data$data)$data
  extracted2 <- extract(user_data$deck[[user_choice$item2]], user_data$data)$data
  
  names(extracted1) <- c("id", "answer1")
  names(extracted2) <- c("id", "answer2")
  
  joined <- merge(extracted1, extracted2, by = "id", all = TRUE)
  
  meta <- list(item1 = user_data$deck[[user_choice$item1]],
               item2 = user_data$deck[[user_choice$item2]])
  
  
  PlotPayload$new(data = joined,
                  meta = meta,
                  settings = settings)
  
}
