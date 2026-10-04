library(testthat)
library(checkmate)
library(here)

# Source the function (in a real Shiny app, pkgload or shiny::loadSupport might do this, 
# but for manual scripts, source it directly)
source(here("R/extract/extract_generics.R"))
source(here("R/extract/extract_single.R"))

testthat("Check that single choice answer: qualitative, ordinal, and numeric-binned are counted correctly.", {
  # ============================================================================
  # create mock data
  mock_data <- data.frame(
    id = 1:3,
    AA01 = c(25, 30, 45),         
    BB01 = c(25, 30, 45),         
    CC01 = c("never", "sometimes", "always"),  
    CC02 = c("this", "that", "that"),  
    DD01_1 = c(1, 0, 1),          
    DD01_2 = c(0, 1, 0)           
  )
  
  # create mock card objects
  mock_qualitative <- list(name = "CC02",
                           label = "mock qualitative")
  class(mock_qualitative) <- c("single_choice", "categorical")
  
  mock_ordinal <- list(name = "CC01", label = "mock ordinal",
                       levels = c("never", "sometimes", "always"))
  class(mock_ordinal) <- c("ordinal", "single_choice")
  
  mock_numeric_binned <- list(name = "BB01",
                              label = "mock numeric binned",
                              breaks = c(0, 18, 35, 65, Inf))
  class(mock_numeric_binned) <- c("ordinal", "single_choice")
  
  mock_deck <- list("CC02" = mock_qualitative,
                    "CC01" = mock_ordinal,
                    "BB01" = mock_numeric_binned)
  
  # ============================================================================
  # 1. HAPPY PATH: Standard Execution
  data_list <- list(
    "qual" = extract(mock_deck$CC02, mock_data)$data,
    "ord"  = extract(mock_deck$CC01, mock_data)$data,
    "num"  = extract(mock_deck$BB01, mock_data)$data
  )
  
  # Basic structure assertions
  lapply(data_list, function(x) {
    expect_data_frame(x, ncols = 3)
    expect_subset(c("category", "count", "percentage"), names(x))
  })
  
  # Check mathematical validity
  # ToDo: Assert that the sum of the 'percentage' column in data_list$qual equals exactly 100.
  
  # factor assertion for ordinal item
  check_factor(data_list$ord$category, levels = c("never", "sometimes", "always"), ordered = TRUE)
  
  # ============================================================================
  # 2. EDGE CASES
  
  # Edge Case 1: The "Ghost Question" (All NAs)
  # ToDo: Create a temporary mock dataset where the CC02 column is entirely NA.
  mock_ghost <- mock_data
  mock_ghost$CC02 <- c(NA, NA, NA)
  ghost_result <- extract(mock_deck$CC02, mock_ghost)$data
  
  # Assert that the resulting dataframe handles the calculation gracefully
  
  expect_data_frame(ghost_result, nrows = 1)
  expect_equal(ghost_result$category[1], "No valid data")
  expect_equal(ghost_result$count[1], 0)

  # Edge Case 2: The "Unseen Zeros" (Empty Factor Levels)
  # ToDo: Create a mock_ordinal_unseen card with levels c("never", "rarely", "sometimes", "always").
  mock_ordinal_unseen <- list(name = "CC01", label = "mock ordinal unseen",
                              levels =  c("never", "rarely", "sometimes", "always"))
  class(mock_ordinal_unseen) <- c("ordinal", "single_choice")
  mock_unseen_result <- extract(mock_ordinal_unseen, mock_data)$data
  
  # Assert that "rarely" still exists in the resulting dataframe's 'category' column, and that its 'count' is exactly 0.
  expect_contains(mock_unseen_result$category, "rarely")
  expect_equal(mock_unseen_result[mock_unseen_result$category == "rarely", "count"], 0)
  
  # Edge Case 3: The "Ugly Label" (Binned interval checking)
  # ToDo: Inspect data_list$num$category. 
  # ToDo: Assert that the resulting levels match the exact mathematical interval notation cut() produces (e.g., "(18,35]"). 
})