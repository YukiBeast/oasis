library(testthat)
library(checkmate)
library(here)

source(here("R/extract/models/user_choice.R"))

test_that("UserChoice validates inputs and assigns defaults correctly", {
  # 1. Clean instantiation with explicit arguments
  uc <- UserChoice$new(
    item1       = "AA01",
    item2       = "BB01",
    share       = TRUE,
    language    = "EN",
    bar_pos     = "dodge",
    fix_y       = FALSE,
    show_legend = TRUE
  )
  
  expect_class(uc, "UserChoice")
  expect_equal(uc$item1, "AA01")
  expect_equal(uc$item2, "BB01")
  expect_true(uc$share)
  expect_equal(uc$language, "EN")
  expect_equal(uc$bar_pos, "dodge")
  expect_false(uc$fix_y)
  expect_true(uc$show_legend)
  
  # 2. Defaults instantiation (only mandatory item1 provided)
  uc_def <- UserChoice$new(item1 = "AA01")
  expect_null(uc_def$item2)
  expect_true(uc_def$share)
  expect_equal(uc_def$language, "EN")
  expect_equal(uc_def$bar_pos, "dodge")
  expect_false(uc_def$fix_y)
  expect_true(uc_def$show_legend)
  
  # 3. Invalid argument type assertions
  expect_error(UserChoice$new(item1 = 1))
  expect_error(UserChoice$new(item1 = "AA01", item2 = 1))
  expect_error(UserChoice$new(item1 = "AA01", share = "TRUE"))
  expect_error(UserChoice$new(item1 = "AA01", language = "IT"))
  expect_error(UserChoice$new(item1 = "AA01", bar_pos = "stacked"))
  expect_error(UserChoice$new(item1 = "AA01", fix_y = "FALSE"))
  expect_error(UserChoice$new(item1 = "AA01", show_legend = 1L))
})
