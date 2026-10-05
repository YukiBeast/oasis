library(testthat)
library(checkmate)
library(here)

source(here("R/models/user_data.R"))
source(here("R/load_data.R"))
source(here("R/extract/create_deck.R"))

test_that("an object of class UserData correctly checks file existence and loads dataset and deck", {
  # Clean instantiation
  mock_data <- UserData$new(
    data_path = here("template_data.xlsx"),
    cb_path   = here("template_codebook.xlsx")
  )
  
  expect_class(mock_data, "UserData")
  expect_data_frame(mock_data$data, min.rows = 1)
  expect_list(mock_data$deck, min.len = 1, names = "named")
  
  # Non-existent paths fail
  expect_error(UserData$new(data_path = here("not_existing.xlsx"),
                            cb_path   = here("not_existing.xlsx")))
  
  # Asymmetric failure (valid data, invalid codebook)
  expect_error(UserData$new(data_path = here("template_data.xlsx"),
                            cb_path   = here("missing_codebook.xlsx")))
})
