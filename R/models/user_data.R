library(R6)
library(checkmate)

UserData <- R6Class(
  classname = "UserData",
  
  public = list(
    # --- Public Fields (UI State) ---
    data_path    = NULL,  # String: indicates the path to the raw dataset
    cb_path      = NULL,  # String: indicates the path to the codebook
    data         = NULL,  # call with user_data$data, clean dataset
    deck         = NULL,  # call with user_data$deck, created with create_deck()
    
    # --- Constructor ---
    initialize = function(data_path,
                          cb_path) {
      
      # TODO: Validate incoming arguments using checkmate
      # e.g., assert_string(item1), assert_flag(share), assert_choice(language, c("EN", "DE")), etc.
      
      assert_file_exists(data_path, access = "r")
      assert_file_exists(cb_path, access = "r")
      
      # TODO: Assign arguments to self
      output <- load_data(data_path, cb_path)
      self$data <- output$dt
      self$deck <- create_deck(output$dt, output$cb, output$scales)
      
    }
  )
)
