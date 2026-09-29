# Once the user inputs the main dataset and the codebook
# this script takes them and prepare them for further uses.

library(readxl)

load_data <- function(data_path, cb_path) {
  
  # 1. first we load and clean the main dataset using the codebook main sheet
  raw_data <- read_excel(data_path,
                         na = c("", "NA"))
  
  raw_cb <- read_excel(cb_path,
                       sheet = "codebook",
                       na = c("", "NA"))

  cb_items <- raw_cb$item
  
  # keep only id, missing, and those columns, whose name contains an item in the cb.
  
  # Create a single regex pattern: "^(AA01|AA02|BB01|BB02)"
  # The "^" ensures it only matches the beginning of the column name
  item_pattern <- paste0("^(", paste(cb_items, collapse = "|"), ")")
  
  # Get all column names and test them in one go
  col_names <- names(raw_data)
  
  # A column is valid if it's exactly "id", exactly "missing", OR matches an item
  keep_cols <- col_names %in% c("id", "missing") | grepl(item_pattern, col_names)
  
  # Subset and return
  filtered_data <- raw_data[, keep_cols]

  # Convert data types
  filtered_data <- type.convert(filtered_data, as.is = TRUE) 
  
  clean_data <- filtered_data[filtered_data$missing < 100, ]
  
  # 2. create a scales object storing all scales defined in the codebook and their dictionaries
  raw_scale_reference <- read_excel(cb_path,
                                    sheet = "scale_reference")
  
  scales <- list()
  for (scale in raw_scale_reference$scale) {
    values <- strsplit(
      raw_scale_reference[raw_scale_reference$scale == scale, ]$reference,
      split = ",")[[1]]
    values <- trimws(values)
    
    scales[[scale]] <- values
  }
  
  output <- list(dt = clean_data,
                 cb = raw_cb,
                 scales = scales)
  
  return(output)
  
}
