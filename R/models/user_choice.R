library(R6)
library(checkmate)

UserChoice <- R6Class(
  classname = "UserChoice",
  
  public = list(
    # --- Public Fields (UI State) ---
    item1    = NULL,  # Character: Key of the first variable in deck (e.g. "AA01")
    item2    = NULL,  # Character or NULL: Key of the second variable (optional)
    share    = NULL,  # Logical: TRUE for proportions/shares, FALSE for absolute counts
    language = NULL,  # Character: "EN" or "DE"
    bar_pos  = NULL,  # Character: "dodge" or "stack"
    fix_y    = NULL,  # Logical: Fix y-axis scale (0 to 1 for share)
    show_legend = NULL, # Logical: should the legend be displayed or not
    
    # --- Constructor ---
    initialize = function(item1,
                          item2    = NULL,
                          share    = TRUE,
                          language = "EN",
                          bar_pos  = "dodge",
                          fix_y    = FALSE,
                          show_legend = TRUE) {
      
      # TODO: Validate incoming arguments using checkmate
      # e.g., assert_string(item1), assert_flag(share), assert_choice(language, c("EN", "DE")), etc.
      
      assert_string(item1)
      assert_string(item2, null.ok = TRUE)
      assert_flag(share)
      assert_choice(language, c("EN", "DE"))
      assert_choice(bar_pos, c("dodge", "stack"), null.ok = TRUE)
      assert_flag(fix_y)
      assert_flag(show_legend)
      
      # TODO: Assign arguments to self
      self$item1    <- item1
      self$item2    <- item2
      self$share    <- share
      self$language <- language
      self$bar_pos  <- bar_pos
      self$fix_y    <- fix_y
      self$show_legend <- show_legend
    }
  )
)
