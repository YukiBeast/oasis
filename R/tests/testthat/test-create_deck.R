library(testthat)
library(checkmate)
library(here)

# Source the function (in a real Shiny app, pkgload or shiny::loadSupport might do this, 
# but for manual scripts, source it directly)

source(here("R/extract/create_deck.R"))

test_that("create_deck assigns correct class and attributes to all items in the codebook", {
  
  # 1. Create Mock Data (we only need the column names for the grepl check)
  mock_data <- data.frame(
    id = 1:3,
    AA01 = c(25, 30, 45),         # Pure numeric
    BB01 = c(25, 30, 45),         # Binned numeric
    CC01 = c("never", "sometimes", "always"),  # Ordinal
    DD01_1 = c(1, 0, 1),          # Multiple choice option 1
    DD01_2 = c(0, 1, 0)           # Multiple choice option 2
  )
  
  # 2. Create Mock Codebook covering all edge cases
  mock_codebook <- data.frame(
    item = c("AA01", "BB01", "CC01", "DD01"),
    label = c("Age continuous", "Age binned", "Frequency", "Devices"),
    class = c("single", "single", "single", "multiple"),
    scale = c("numeric", "numeric", "freq", NA),
    breaks = c(NA, "18, 35, 65", NA, NA),
    stringsAsFactors = FALSE
  )
  
  # 3. Create Mock Scales dictionary
  mock_scales <- list(
    freq = c("never", "sometimes", "always")
  )
  
  # 4. Run the isolated function
  deck <- create_deck(mock_data, mock_codebook, mock_scales)
  
  # --- ASSERTIONS ---
  
  # Overall structure
  expect_list(deck, len = 4)
  expect_named(deck, c("AA01", "BB01", "CC01", "DD01"))
  
  # Case 1: Pure Numeric (Class 'single', Scale 'numeric', breaks NA)
  expect_class(deck$AA01, c("numeric", "single_choice"))
  expect_null(deck$AA01$breaks)
  
  # Case 2: Binned Numeric (Class 'single', Scale 'numeric', breaks provided)
  expect_class(deck$BB01, c("ordinal", "single_choice"))
  expect_equal(deck$BB01$breaks, c(18, 35, 65))
  
  # Case 3: Standard Ordinal (Class 'single', Scale 'freq')
  expect_class(deck$CC01, c("ordinal", "single_choice"))
  expect_equal(deck$CC01$levels, c("never", "sometimes", "always"))
  
  # Case 4: Multiple Choice (Class 'multiple')
  expect_class(deck$DD01, c("multiple_choice", "categorical"))
  expect_equal(deck$DD01$prefix, "^DD01_")
})
