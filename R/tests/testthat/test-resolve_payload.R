# library(testthat)
# library(checkmate)
# library(here)
# 
# source(here("R/models/user_choice.R"))
# source(here("R/models/user_data.R"))
# source(here("R/pipeline/resolve_payload.R"))
# 
# # Minimal mock extraction generic and method for headless testing
# # (if not already sourced from your R/extract/ directory)
# if (!exists("extract")) {
#   extract <- function(x, data, ...) UseMethod("extract")
# }
# extract.default <- function(x, data, ...) {
#   # Returns standard contract: list(meta = x, data = data.frame(id, answer))
#   val_col <- x$prefix
#   out_df <- data.frame(
#     id = data$id,
#     answer = data[[val_col]],
#     stringsAsFactors = FALSE
#   )
#   list(meta = x, data = out_df)
# }
# 
# test_that(
#   "resolve_payload correctly checks classes and produces uniform univariate and bivariate payloads",
#   {
# 
#   }
#   )
# 
