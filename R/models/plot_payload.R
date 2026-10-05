library(R6)
library(checkmate)

PlotPayload <- R6Class(
  classname = "PlotPayload",
  
  public = list(
    data = NULL,
    meta = NULL,
    settings = NULL,
    
    initialize = function(data, meta, settings) {
      
      # check data
      assert_data_frame(data)
      assert_subset(c("id", "answer1"), names(data))
      
      # check meta
      assert_list(meta, names = "named")
      assert_subset("item1", names(meta))
      
      # check settings
      assert_list(settings, names = "named")
      assert_subset(
        c("share", "language", "bar_pos", "fix_y", "show_legend"), 
        names(settings)
      )
      
      self$data <- data
      self$meta <- meta
      self$settings <- settings
    }
  )
  
)