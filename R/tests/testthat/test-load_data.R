# tests/testthat/test-load_data.R

library(testthat)
library(checkmate)
library(here)

# Source the function (in a real Shiny app, pkgload or shiny::loadSupport might do this, 
# but for manual scripts, source it directly)
source(here("R/load_data.R"))

test_that("load_data imports and structures data correctly", {
  
  # Define paths (relative to the test directory, or use absolute paths for testing)
  data_path <- here("template_data.xlsx")
  cb_path   <- here("template_codebook.xlsx")
  
  # Run the function
  result <- load_data(data_path, cb_path)
  
  # 1. Test the overall output structure
  expect_list(result, len = 3, any.missing = FALSE)
  expect_named(result, c("dt", "cb", "scales"))
  
  # 2. Test the dataset (dt)
  expect_data_frame(result$dt)
  expect_subset(c("id", "missing"), names(result$dt))
  
  # 3. Test the codebook (cb)
  expect_data_frame(result$cb)
  expect_subset(c("item", "label", "class", "scale", "breaks"), names(result$cb))
  
  # 4. Test the scales list
  expect_list(result$scales, any.missing = FALSE)
})
