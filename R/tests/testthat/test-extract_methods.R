library(testthat)
library(checkmate)
library(here)

# Source the function (in a real Shiny app, pkgload or shiny::loadSupport might do this, 
# but for manual scripts, source it directly)
source(here("R/extract/extract_generics.R"))
source(here("R/extract/return_empty_data.R"))
source(here("R/extract/extract_binned.R"))
source(here("R/extract/extract_ordinal.R"))
source(here("R/extract/extract_categorical.R"))


# Define mock_data and mock_deck for all tests:
# create mock data
mock_data <- data.frame(
  id = 1:3,
  AA01 = c(25, 30, 45),         
  BB01 = c(18, 30, 45),         
  CC01 = c("never", "sometimes", "always"),  
  CC02 = c("this", "that", "that"),  
  "DD01_1: football" = c(1, 0, 1),          
  "DD01_2: volleyball" = c(0, 1, 0),
  check.names = FALSE
)

# create mock card objects
mock_qualitative <- list(name = "CC02",
                         label = "mock qualitative")
class(mock_qualitative) <- c("categorical", "single_choice")

mock_ordinal <- list(name = "CC01", label = "mock ordinal",
                     levels = c("never", "sometimes", "always"))
class(mock_ordinal) <- c("ordinal", "single_choice")

mock_binned <- list(name = "BB01",
                            label = "mock numeric binned",
                            breaks = c(0, 18, 35, 65, Inf))
class(mock_binned) <- c("binned", "single_choice")

mock_multiple <- list(name = "DD01", label = "some MCQ",
                      prefix = "^DD01_")
class(mock_multiple) <- c("multiple_choice", "categorical")

mock_deck <- list("CC02" = mock_qualitative,
                  "CC01" = mock_ordinal,
                  "BB01" = mock_binned,
                  "DD01" = mock_multiple)


# ===========================================
# test for extract.binned()
# ===========================================
test_that(
  "The method extract.binned correctly extracts numeric binned variables, manage the interval
         labels and flawlessly handles complete missing answers",
  {
    # clean path
    extracted <- extract(mock_deck$BB01, mock_data)$data
    expect_data_frame(extracted, ncols = 2)
    expect_equal(names(extracted), c("id", "answer1"))
    expect_factor(extracted$answer1, levels = c("0-17", "18-34", "35-64", "65+"),
                  ordered = TRUE)
    expect_equal(as.character(extracted$answer1[[1]]), "18-34")
    
    # values outside categories
    mock_data$BB01[[1]] <- -10
    extracted <- extract(mock_deck$BB01, mock_data)$data
    expect_scalar_na(extracted$answer1[[1]])
    
    # ghost column: all values are missing
    mock_data$BB01 <- c(NA, NA, NA)
    extracted <- extract(mock_deck$BB01, mock_data)$data
    expect_data_frame(extracted, ncols = 2, nrows = 0)
    expect_equal(names(extracted), c("id", "answer1"))
    
  }
)


# ====================================================
# test for extract.ordinal()
# ===================================================
test_that(
"The method extract.ordinal() correctly extracts ordinal items and maintains their order +
 levels that are not present in the data are kept",
{
  extracted <- extract(mock_deck$CC01, mock_data)$data
  expect_data_frame(extracted, ncols = 2)
  expect_equal(names(extracted), c("id", "answer1"))
  expect_factor(extracted$answer1, levels = c("never", "sometimes", "always"),
                ordered = TRUE)
  
  # not appearing categories are preserved
  mock_deck$CC01$levels <- c("never", "rarely", "sometimes", "always")
  extracted <- extract(mock_deck$CC01, mock_data)$data
  expect_factor(extracted$answer1, levels = c("never", "rarely", "sometimes", "always"),
                ordered = TRUE)
  
  # values outside categories
  mock_data$CC01[[1]] <- "often"
  extracted <- extract(mock_deck$CC01, mock_data)$data
  expect_scalar_na(extracted$answer1[[1]])
  
  # ghost column: all values are missing
  mock_data$CC01 <- c(NA, NA, NA)
  extracted <- extract(mock_deck$CC01, mock_data)$data
  expect_data_frame(extracted, ncols = 2, nrows = 0)
  expect_equal(names(extracted), c("id", "answer1"))
  
}
)


# ==================================================================
# test for extract.categorical()
# ==================================================================
test_that(
  "The method extract.categorical correctly handles categorical items and save them as unordered factors",
  {
    # clean path
    extracted <- extract(mock_deck$CC02, mock_data)$data
    expect_data_frame(extracted, ncols = 2)
    expect_equal(names(extracted), c("id", "answer1"))
    expect_factor(extracted$answer1, levels = c("this", "that"),
                  ordered = FALSE)
    
    # ghost column: all values are missing
    mock_data$CC02 <- c(NA, NA, NA)
    extracted <- extract(mock_deck$CC02, mock_data)$data
    expect_data_frame(extracted, ncols = 2, nrows = 0)
    expect_equal(names(extracted), c("id", "answer1"))
  }
)


# ==================================================================
# test for extract_multiple_choice()
# ==================================================================
test_that(
  "The method extract.multiple() correctly counts answers from MCQ and that their labels are handled correctly",
  {
    extracted <- extract(mock_deck$DD01, mock_data)$data
    expect_data_frame(extracted, ncols = 2)
    expect_equal(names(extracted), c("id", "answer1"))
    expect_factor(extracted$answer1, levels = c("football", "volleyball"),
                  ordered = FALSE)
  }
)
